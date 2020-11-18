/**
 * 登录页
 */
import { get } from '../../../utils';

/**
 * 测试接口
 * @param {JSON} params
 */
export async function testInterface(params) {
    const { SCode, IsRoot, ParentCode, appID, userid, layer } = params;
    const result = get({
        url: `/aaabw10075/30819.JFF2PEVB7VE3B4HMBHBPGGLE9A9MBF0I15901281266760.7986833178438246.526032101/PortalMas/GetOrgListAjax?SCode=${SCode}&IsRoot=${IsRoot}&ParentCode=${ParentCode}&appID=${appID}&userid=${userid}&layer=${layer}`
    });
    return result;
}