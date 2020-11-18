/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
import { StyleSheet, Text, SafeAreaView } from 'react-native';
import { Provider } from 'react-redux';
import { create } from 'dva-core';
// 引入所有 dva model
import models from './src/models';
// 引入入口
import Main from './src/Main';


const app = create({
  // history: createHistory(),
  // 以下为新增内容
  onReducer: r => (state, action) => {
    // 登出,清空 model,只保留指定 model 信息
    if (action.type === 'user/logout') {

      // 退出登录时清空所有state
      const savedState = {};
      // console.log("logout savedState = ", savedState);
      return savedState;
    } else {
      return r(state, action);
    }
  },
  onError(e) {
    console.error(e.message);
  },
});

models.forEach(o => {
  // 装载models对象
  app.model(o);
});
// app.model(networkModel);

app.start(); // 实例初始化

const store = app._store; // 获取redux的store对象供react-redux使用
console.log("store", store)


export default class App extends React.Component {

  render() {
    return (
        <Provider store={store}>
          <Main />
        </Provider>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
