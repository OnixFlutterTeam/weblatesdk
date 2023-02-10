class Const {
  static const packageName = 'WebLate SDK';
  static const success = '$packageName: Initialized Successfully.';
  static const apiError = '$packageName: Api Error.';
  static const notInitialized = '$packageName: Not Initialized Exception';
  static const localeNotFound = '$packageName: Locale Not Found Exception';
  static const keyNotFound = '$packageName: Key Not Found Exception';
  static const storageIOError = '$packageName: Storage IO Exception';

  static const defaultConnectTimeout = 15000;
  static const defaultReceiveTimeout = 15000;
  static const defaultCommonHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Headers':
        'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
    'Access-Control-Allow-Methods': 'GET',
  };
}
