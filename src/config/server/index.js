// 引入应用全局配置
import { appEnv, appConfig } from '../appConfig';
/**
 * 开发测试环境配置
 */
const devConfig = {
  // 开发测试环境地址
  baseUrl: 'https://xxxx',
  previewServerBaseUrl: 'http://xxxx',
  defaultTimeout: 45000, // 默认超时45秒
  prefix: '',
  // 测试移动平台应用 id
  application: 'xxxxx',
  dataUserstore: ''
};

/**
 * UAT 环境配置
 */
const uatConfig = {
  // 开发测试环境地址
  baseUrl: 'http://xxxx',
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
  baseUrl: 'http://xxxxxx',
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
