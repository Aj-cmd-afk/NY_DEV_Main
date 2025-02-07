-- {"api":"PostMerchantUpdate","migration":"endpoint","param":"MerchantAPI MerchantUpdateEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_UPDATE'
  WHERE endpoint = 'MerchantAPI MerchantUpdateEndpoint';

-- {"api":"PostMerchantUpdate","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_UPDATE'
  WHERE endpoint = 'MerchantAPI PostMerchantUpdateEndpoint';

-- {"api":"PostMerchantServiceConfigMapsUpdate","migration":"endpoint","param":"MerchantAPI MapsServiceConfigUpdateEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SERVICE_CONFIG_MAPS_UPDATE'
  WHERE endpoint = 'MerchantAPI MapsServiceConfigUpdateEndpoint';

-- {"api":"PostMerchantServiceConfigMapsUpdate","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SERVICE_CONFIG_MAPS_UPDATE'
  WHERE endpoint = 'MerchantAPI PostMerchantServiceConfigMapsUpdateEndpoint';

-- {"api":"PostMerchantServiceUsageConfigMapsUpdate","migration":"endpoint","param":"MerchantAPI MapsServiceConfigUsageUpdateEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SERVICE_USAGE_CONFIG_MAPS_UPDATE'
  WHERE endpoint = 'MerchantAPI MapsServiceConfigUsageUpdateEndpoint';

-- {"api":"PostMerchantServiceUsageConfigMapsUpdate","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SERVICE_USAGE_CONFIG_MAPS_UPDATE'
  WHERE endpoint = 'MerchantAPI PostMerchantServiceUsageConfigMapsUpdateEndpoint';

-- {"api":"PostMerchantServiceConfigSmsUpdate","migration":"endpoint","param":"MerchantAPI SmsServiceConfigUpdateEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SERVICE_CONFIG_SMS_UPDATE'
  WHERE endpoint = 'MerchantAPI SmsServiceConfigUpdateEndpoint';

-- {"api":"PostMerchantServiceConfigSmsUpdate","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SERVICE_CONFIG_SMS_UPDATE'
  WHERE endpoint = 'MerchantAPI PostMerchantServiceConfigSmsUpdateEndpoint';

-- {"api":"PostMerchantServiceUsageConfigSmsUpdate","migration":"endpoint","param":"MerchantAPI SmsServiceConfigUsageUpdateEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SERVICE_USAGE_CONFIG_SMS_UPDATE'
  WHERE endpoint = 'MerchantAPI SmsServiceConfigUsageUpdateEndpoint';

-- {"api":"PostMerchantServiceUsageConfigSmsUpdate","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SERVICE_USAGE_CONFIG_SMS_UPDATE'
  WHERE endpoint = 'MerchantAPI PostMerchantServiceUsageConfigSmsUpdateEndpoint';

-- {"api":"PostMerchantConfigOperatingCityCreate","migration":"endpoint","param":"MerchantAPI CreateMerchantOperatingCityEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_CONFIG_OPERATING_CITY_CREATE'
  WHERE endpoint = 'MerchantAPI CreateMerchantOperatingCityEndpoint';

-- {"api":"PostMerchantConfigOperatingCityCreate","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_CONFIG_OPERATING_CITY_CREATE'
  WHERE endpoint = 'MerchantAPI PostMerchantConfigOperatingCityCreateEndpoint';

-- {"api":"PostMerchantSpecialLocationUpsert","migration":"endpoint","param":"MerchantAPI UpsertSpecialLocationEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SPECIAL_LOCATION_UPSERT'
  WHERE endpoint = 'MerchantAPI UpsertSpecialLocationEndpoint';

-- {"api":"PostMerchantSpecialLocationUpsert","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SPECIAL_LOCATION_UPSERT'
  WHERE endpoint = 'MerchantAPI PostMerchantSpecialLocationUpsertEndpoint';

-- {"api":"DeleteMerchantSpecialLocationDelete","migration":"endpoint","param":"MerchantAPI DeleteSpecialLocationEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/DELETE_MERCHANT_SPECIAL_LOCATION_DELETE'
  WHERE endpoint = 'MerchantAPI DeleteSpecialLocationEndpoint';

-- {"api":"DeleteMerchantSpecialLocationDelete","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/DELETE_MERCHANT_SPECIAL_LOCATION_DELETE'
  WHERE endpoint = 'MerchantAPI DeleteMerchantSpecialLocationDeleteEndpoint';

-- {"api":"PostMerchantSpecialLocationGatesUpsert","migration":"endpoint","param":"MerchantAPI UpsertSpecialLocationGateEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SPECIAL_LOCATION_GATES_UPSERT'
  WHERE endpoint = 'MerchantAPI UpsertSpecialLocationGateEndpoint';

-- {"api":"PostMerchantSpecialLocationGatesUpsert","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/POST_MERCHANT_SPECIAL_LOCATION_GATES_UPSERT'
  WHERE endpoint = 'MerchantAPI PostMerchantSpecialLocationGatesUpsertEndpoint';

-- {"api":"DeleteMerchantSpecialLocationGatesDelete","migration":"endpoint","param":"MerchantAPI DeleteSpecialLocationGateEndpoint","schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/DELETE_MERCHANT_SPECIAL_LOCATION_GATES_DELETE'
  WHERE endpoint = 'MerchantAPI DeleteSpecialLocationGateEndpoint';

-- {"api":"DeleteMerchantSpecialLocationGatesDelete","migration":"endpointV2","param":null,"schema":"atlas_bap_dashboard"}
UPDATE atlas_bap_dashboard.transaction
  SET endpoint = 'RIDER_MANAGEMENT/MERCHANT/DELETE_MERCHANT_SPECIAL_LOCATION_GATES_DELETE'
  WHERE endpoint = 'MerchantAPI DeleteMerchantSpecialLocationGatesDeleteEndpoint';
