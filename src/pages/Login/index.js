import React from 'react';
import {
    StyleSheet,
    Text,
    TouchableOpacity,
    View,
    Image,
    FlatList,
    Button,
    TextInput,
    StatusBar,
    Alert
} from 'react-native';
import { NativeModules } from 'react-native';
import { connect } from 'react-redux';
import { ToastUtils } from '../../utils';

class Login extends React.Component {


    constructor(props, context) {
        super(props, context);
        this.state = {
            autoLogin: false,
            username: "",
            password: "",
            agreeItem1: true,
            checkboxItem1: true,
            buttonList: [
                { name: '登录', clickEvent: this.loginClick },
                { name: '获取设备标识', clickEvent: this.getDeviceInfo },
                { name: '附件预览', clickEvent: this.openNativeFile },
                { name: 'webview', clickEvent: this.openWebView },
                { name: '版本信息', clickEvent: this.getAppVersionInfo },
                { name: 'test', clickEvent: this.test }
            ]
        };
    }

    componentDidMount() {
        console.log('this.props', this.props)
    }

    loginClick = () => {
        this.props.navigation.navigate('HomeTab')
    };

    //获取设备标识
    getDeviceInfo = () => {
        const HXDevicePlugin = NativeModules.HXDevicePlugin;
        HXDevicePlugin.findEvents(this.showDeviceInfo);
    };

    showDeviceInfo = (deviceInfo) => {
        console.log('deviceInfo----', deviceInfo);
        let newDeviceInfo = JSON.stringify(deviceInfo);
        Alert.alert(newDeviceInfo)
    }

    //获取版本信息
    getAppVersionInfo = () => {

    };
    test = () => {
        this.props.dispatch({
            type: 'loginModels/testInterface',
            payload: {
                SCode: 'FW',
                IsRoot: 'N',
                ParentCode: 'hrmdepartment49262',
                appID: 'aaabw10075',
                userid: '36969',
                layer: '0'
            },
        }).then((result) => {
            console.log('测试接口的返回信息', result);
            if(result.ResultCode == '0'){
                Alert.alert('请求成功')
                // ToastUtils.show('接口请求成功！')
            }
        })
    };
    //打开附件预览
    openNativeFile = () => {

    };

    //打开webview
    openWebView = () => {
        // Alert.alert('打开webview')
        console.log('打开webview-----')
        const HXwebviewPlugin = NativeModules.HXwebviewPlugin;
        HXwebviewPlugin.addEvent('嘿嘿嘿~')
    };

    render() {
        const { buttonList } = this.state
        return (
            <View style={{ flex: 1 }}>
                <StatusBar backgroundColor="blue" />
                <View style={{ justifyContent: 'center', alignItems: 'center', width: '100%', height: 50, backgroundColor: '#108ee9' }}>
                    <Text style={{ color: 'white', fontSize: 20, letterSpacing: 2 }}>登录</Text>
                </View>
                <View style={{ marginTop: 30, flexDirection: 'row', }}>
                    <Image
                        style={{ width: 100, height: 100, marginLeft: 20 }}
                        source={require('../../assets/demoIcon/gt_logo.png')}
                    />
                    <Image
                        style={{ width: 200, height: 100, marginLeft: 20, resizeMode: 'contain' }}
                        source={require('../../assets/demoIcon/gt_logo_text.png')}
                    />
                </View>


                <View style={{ marginTop: 50, marginHorizontal: 20, }}>
                    <View style={{ justifyContent: 'flex-start', flexDirection: 'row', justifyContent: 'flex-start', alignItems: 'center' }}>
                        <Image
                            style={{ width: 20, height: 20, marginLeft: 20, resizeMode: 'contain' }}
                            source={require('../../assets/demoIcon/username.png')}
                        />
                        <View style={{ height: 50, justifyContent: 'center' }}>
                            <TextInput
                                realDomRef={r => (this.usernameNode = r)}
                                placeholder="用户id"
                                multiline={false}
                                numberOfLines={4}
                                autoCapitalize="none"
                                onChangeText={username => {
                                    if (username.length > 30) return;
                                    // this.setState({ username }, () => {
                                    //     this.updateLoginButtonStatus();
                                    // });
                                }}
                                // value={this.state.username}
                                // disableFullscreenUI={true}
                                onBlur={() => {
                                    // this.setState({
                                    //     textUserBorder: false,
                                    // });
                                }}
                                style={{
                                    fontSize: 20,
                                    // height: 50,
                                    marginLeft: 20,
                                }}
                                onFocus={() => {

                                }}
                            />
                        </View>
                    </View>
                    <View style={{ flexDirection: 'row', justifyContent: 'flex-start', alignItems: 'center' }}>
                        <Image
                            style={{ width: 20, height: 20, marginLeft: 20, resizeMode: 'contain' }}
                            source={require('../../assets/demoIcon/password.png')}
                        />
                        <View style={{ height: 50, justifyContent: 'center' }}>

                            <TextInput
                                placeholder="****"
                                multiline={false}
                                numberOfLines={4}
                                autoCapitalize="none"
                                onChangeText={password => {
                                    if (password.length > 30) return;
                                    // this.setState({ password }, () => {
                                    //     this.updateLoginButtonStatus();
                                    // });
                                }}
                                // value={this.state.password}
                                // disableFullscreenUI={true}
                                onBlur={() => {
                                    // this.setState({
                                    //     textUserBorder: false,
                                    // });
                                }}
                                style={{
                                    fontSize: 20,
                                    // height: 50,
                                    marginLeft: 20,
                                }}
                                onFocus={() => {

                                }}
                            />
                        </View>
                    </View>
                </View>
                <View style={{ flex: 1, marginHorizontal: 20, marginTop: 50 }}>
                    {
                        buttonList.map((item, index) => {
                            return (
                                <TouchableOpacity
                                    onPress={item.clickEvent}
                                    style={styles.buttonStyle}
                                    key={index}
                                >
                                    <Text style={styles.buttonText}>
                                        {item.name}
                                    </Text>
                                </TouchableOpacity>
                            )
                        })
                    }

                </View>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    buttonStyle: {
        width: '100%',
        height: 50,
        marginBottom: 13,
        backgroundColor: '#108ee9',
        borderRadius: 5,
        justifyContent: 'center',
        alignItems: 'center'

    },
    buttonText: {
        color: 'white',
        fontSize: 20
    }
})

export default connect((state) => {
    return { ...state };
})(Login);
