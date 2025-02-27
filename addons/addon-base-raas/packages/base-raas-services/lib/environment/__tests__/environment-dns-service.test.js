/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License").
 *  You may not use this file except in compliance with the License.
 *  A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 *  or in the "license" file accompanying this file. This file is distributed
 *  on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 *  express or implied. See the License for the specific language governing
 *  permissions and limitations under the License.
 */

const ServicesContainer = require('@aws-ee/base-services-container/lib/services-container');

// Mocked dependencies
jest.mock('@aws-ee/base-services/lib/settings/env-settings-service');
const SettingsServiceMock = require('@aws-ee/base-services/lib/settings/env-settings-service');

const Aws = require('@aws-ee/base-services/lib/aws/aws-service');

jest.mock('../service-catalog/environment-sc-service');
const EnvironmentScService = require('../service-catalog/environment-sc-service');

const EnvironmentDnsService = require('../environment-dns-service');

describe('EnvironmentDnsService', () => {
  let service = null;
  let environmentScService = null;
  let settings = null;

  beforeEach(async () => {
    const container = new ServicesContainer();
    container.register('settings', new SettingsServiceMock());
    container.register('environmentScService', new EnvironmentScService());
    container.register('environmentDnsService', new EnvironmentDnsService());
    container.register('aws', new Aws());
    await container.initServices();

    // Get instance of the service we are testing
    service = await container.find('environmentDnsService');
    environmentScService = await container.find('environmentScService');
    settings = await container.find('settings');
  });

  describe('Test changePrivateRecordSet', () => {
    it('should call changeResourceRecordSets', async () => {
      const requestContext = { principalIdentifier: { uid: 'u-testuser' } };
      const route53Client = jest.fn();
      service.changeResourceRecordSets = jest.fn();
      environmentScService.getClientSdkWithEnvMgmtRole = jest.fn(() => {
        return route53Client;
      });
      settings.get = jest.fn(key => {
        if (key === 'domainName') {
          return 'test.aws';
        }
        throw Error(`${key} not found`);
      });
      await service.changePrivateRecordSet(requestContext, 'CREATE', 'rstudio', 'test-id', '10.1.1.1', 'HOSTEDZONE123');
      expect(service.changeResourceRecordSets).toHaveBeenCalledWith(
        route53Client,
        'HOSTEDZONE123',
        'CREATE',
        'rstudio-test-id.test.aws',
        'A',
        '10.1.1.1',
      );
      expect(service.changeResourceRecordSets).toHaveBeenCalledTimes(1);
    });
  });

  describe('Test changeResourceRecordSets', () => {
    it('should call Route53 changeResourceRecordSets', async () => {
      const route53Client = {
        client: 'route53Mock',
        changeResourceRecordSets: jest.fn(() => {
          return {
            promise: () => {},
          };
        }),
      };
      await service.changeResourceRecordSets(
        route53Client,
        'HOSTEDZONE123',
        'CREATE',
        'rstudio-test-id.test.aws',
        'A',
        '10.1.1.1',
      );
      expect(route53Client.changeResourceRecordSets).toHaveBeenCalledTimes(1);
      expect(route53Client.changeResourceRecordSets).toHaveBeenCalledWith({
        HostedZoneId: 'HOSTEDZONE123',
        ChangeBatch: {
          Changes: [
            {
              Action: 'CREATE',
              ResourceRecordSet: {
                Name: 'rstudio-test-id.test.aws',
                Type: 'A',
                TTL: 300,
                ResourceRecords: [{ Value: '10.1.1.1' }],
              },
            },
          ],
        },
      });
    });
  });

  describe('Test createPrivateRecord', () => {
    it('should call changePrivateRecordSet', async () => {
      const requestContext = { principalIdentifier: { uid: 'u-testuser' } };
      service.changePrivateRecordSet = jest.fn();
      await service.createPrivateRecord(requestContext, 'rstudio', 'test-id', '10.1.1.1', 'HOSTEDZONE123');
      expect(service.changePrivateRecordSet).toHaveBeenCalledTimes(1);
      expect(service.changePrivateRecordSet).toHaveBeenCalledWith(
        requestContext,
        'CREATE',
        'rstudio',
        'test-id',
        '10.1.1.1',
        'HOSTEDZONE123',
      );
    });
  });

  describe('Test deletePrivateRecord', () => {
    it('should call changePrivateRecordSet', async () => {
      const requestContext = { principalIdentifier: { uid: 'u-testuser' } };
      service.changePrivateRecordSet = jest.fn();
      await service.deletePrivateRecord(requestContext, 'rstudio', 'test-id', '10.1.1.1', 'HOSTEDZONE123');
      expect(service.changePrivateRecordSet).toHaveBeenCalledTimes(1);
      expect(service.changePrivateRecordSet).toHaveBeenCalledWith(
        requestContext,
        'DELETE',
        'rstudio',
        'test-id',
        '10.1.1.1',
        'HOSTEDZONE123',
      );
    });
  });
});
