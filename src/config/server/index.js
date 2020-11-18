// 引入应用全局配置
import { appEnv, appConfig } from '../appConfig';
/**
 * 开发测试环境配置
 */
const devConfig = {
  // 开发测试环境地址
  // baseUrl: 'https://plist.horitech.com.cn:8086/mobile/',
  // baseUrl: 'http://39.105.172.162:8600/oa/',
  // baseUrl: 'http://192.168.0.105:8080',
  // baseUrl: 'http://10.20.209.119:8080',
  baseUrl: 'https://mobile.sinochem.com:28443/UATServer',
  previewServerBaseUrl: 'http://10.20.209.181:8088',
  defaultTimeout: 45000, // 默认超时45秒
  prefix: '',
  // 测试移动平台应用 id
  application: 'c3c410fff3cc414084764ec20a2c72ca',
  dataUserstore: ''
};

/**
 * UAT 环境配置
 */
const uatConfig = {
  // 开发测试环境地址
  baseUrl: 'http://uat.example-server.com',
  defaultTimeout: 45000, // 默认超时45秒
  prefix: '',
  // 测试移动平台应用 id
  application: 'uat',
};

/**
 * 生产环境配置
 */
const productConfig = {
  // 生产地址
  baseUrl: 'http://product.example-server.com',
  defaultTimeout: 45000, // 默认超时45秒
  prefix: '',
  // 生产移动平台应用 id
  application: 'product',
};

export default function getServerConfig() {
  // 开发环境
  if (appConfig.ENV === appEnv.DEV) {
    return devConfig;
  }
  // UAT 环境
  if (appConfig.ENV === appEnv.UAT) {
    return uatConfig;
  }
  // 生产环境
  if (appConfig.ENV === appEnv.PRODUCT) {
    return productConfig;
  }
  // 默认为开发环境
  return devConfig;
}
