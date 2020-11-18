import { testInterface } from '../services'

/**
 * 登录页 Model
 */
const loginPageModels = {
    namespace: 'loginModels',
    state: {
    },
  
    effects: {

      // 测试接口
      *testInterface({ payload }, { call, put, select }) {
        const response = yield call(testInterface, payload);
        return response
      },

      
    },
  
    reducers: {
      /**
       * 保存会议列表
       * @param {state} state 原始 state
       * @param {action} action action，含返回数据信息
       */
  
      saveWeekMeetingList(state, action) {
        const { payload } = action;
        // 更新会议详情信息
        return { ...state, ...payload };
      },
      
    },
  };
  
export default loginPageModels;
  