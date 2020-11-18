
/**
 * 首页 Model
 */
const homePageModels = {
  namespace: 'homeModels',
  state: {
    homeString:'这里是主页的model呦'
  },

  effects: {
    // 获取会议列表信息
    *meetingList({ payload }, { call, put, select }) {
      const response = yield call(meetingList, payload);
      if (payload.isInit) {
        yield put(createAction('saveWeekMeetingList')({ weekMeetingList: response.data.list }));
      }
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

export default homePageModels;