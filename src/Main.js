import React from 'react';
import { TextInput, Text } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';


/**
 * 应用主路由，含底部导航相关子路由
 */
import AppStack from './routes/AppStack';




//字体不随系统字体变化
TextInput.defaultProps = Object.assign({}, TextInput.defaultProps, {
    defaultProps: false,
});
Text.defaultProps = Object.assign({}, Text.defaultProps, {
    allowFontScaling: false,
});

const Stack = createStackNavigator();

class Main extends React.Component {
    constructor(props) {
        super(props);

    }


    componentDidMount() {

    }

    componentWillUnmount() {
    }

    render() {

        return (
            <NavigationContainer>
                <Stack.Navigator>
                    <Stack.Screen
                        name="App"
                        component={AppStack}
                        options={{ headerShown: false }}
                    />
                </Stack.Navigator>
            </NavigationContainer>
        );
    }
}

export default Main;
