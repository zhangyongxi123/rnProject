import React from 'react';
import { StyleSheet, View, TouchableOpacity, Text, Alert, Image } from 'react-native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createStackNavigator } from '@react-navigation/stack';
// import { ToastUtils } from '../utils';
// import { globalConfig } from '../config'
// import {connect} from 'react-redux';
// import {FontConfig} from '../config/CommonConfig';
/**
 * 导入 TAB 页组件
 */
import Home from '../pages/Home';
import Meeting from '../pages/Meeting';
import Login from '../pages/Login';
import Mine from '../pages/Mine';

const Tab = createBottomTabNavigator();

const Stack = createStackNavigator();

const tabIconArray = [
  { label: '首页', tabIconName: 'home', tabIconName: 'homeed', },
  { label: '待办', tabIconName: 'todo', tabIconName: 'todoed', },
  { label: '会议', tabIconName: 'meeting', tabIconName: 'meetinged', },
  { label: '通讯录', tabIconName: 'contact', tabIconName: 'contacted', },
  { label: '我的', tabIconName: 'my', tabIconName: 'myed', },
]

/**
 * Tab 页配置
 */
const HomeTabs = () => {
  return (
    <Tab.Navigator
      initialRouteName="MeetingTab"

    >
      <Tab.Screen

        options={{
          tabBarLabel: '首页',
          tabBarIcon: ({ focused, color, size }) => {
            if (focused) {
              return <Image source={require('../assets/demoIcon/home1.png')} style={{width: 20,height: 20}} />
            } else {
              return <Image source={require('../assets/demoIcon/home.png')} style={{width: 20,height: 20}} />
            }
          },
        }}
        name="HomeTab" component={Home} />

      <Tab.Screen
        name="MeetingTab"
        component={Meeting}
        options={{
          tabBarLabel: '会议',
          tabBarIcon: ({ focused, color, size }) => {
            if (focused) { 
              return <Image source={require('../assets/demoIcon/list1.png')} style={{width: 20,height: 20}} />
            } else {
              return <Image source={require('../assets/demoIcon/list.png')} style={{width: 20,height: 20}} />
            }
          },
        }}
      />
      <Tab.Screen
        name="MineTab"
        component={Mine}
        options={{
          tabBarLabel: '我的',
          tabBarIcon: ({ focused, color, size }) => {
            if (focused) {
              return <Image source={require('../assets/demoIcon/setting1.png')} style={{width: 20,height: 20}} />
            } else {
              return <Image source={require('../assets/demoIcon/setting.png')} style={{width: 20,height: 20}} />
            }
          },
        }}
      />
      <Tab.Screen name="LoginTab" component={Login}
        options={{
          tabBarLabel: '登录',
          tabBarIcon: ({ focused, color, size }) => {
            if (focused) {
              return <Image source={require('../assets/demoIcon/home1.png')} style={{width: 20,height: 20}} />
            } else {
              return <Image source={require('../assets/demoIcon/home.png')} style={{width: 20,height: 20}} />
            }
          },
        }}
      />
    </Tab.Navigator>
  );
};



export default function App() {
  return (
    <Stack.Navigator
      headerMode={'none'}

    // screenOptions={({ route, navigation }) => {
    //   globalConfig.currentRouter.routerName = route.name;
    // }}
    >

      {/* Tab 页配置 */}
      <Stack.Screen
        name="Home"
        component={HomeTabs}
        options={{ headerShown: false }}
      />

    </Stack.Navigator>
  );
}

const styles = StyleSheet.create({
  tabbarContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    backgroundColor: '#ffffff',
    borderTopWidth: 1,
    borderTopColor: '#f2f2f2'
  },
  tabItem: {
    paddingVertical: 12,
    marginHorizontal: 20,
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
    // width: 100,
    minWidth: 80,
    // backgroundColor: 'red',
    alignItems: 'center',
  },
});
