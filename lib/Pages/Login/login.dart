import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PersonData {
  String? name = '';
  String? password = '';
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with RestorationMixin {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  PersonData person = PersonData();

  late FocusNode _name, _password;

  @override
  void initState() {
    super.initState();
    _name = FocusNode();
    _password = FocusNode();
  }

  @override
  void dispose() {
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  //登录
  void _login() async {
    final form = _formKey.currentState!;
    if (!form.validate()) {
      _autoValidateModeIndex.value = AutovalidateMode.always.index;
      _btnController.error();
      await Future.delayed(const Duration(seconds: 1));
      _btnController.reset();
    } else {
      form.save();
      //TODO: 登录并初始化，一些费时操作
      ///
      ///
      await Future.delayed(const Duration(seconds: 1));
      _btnController.success();
      await Future.delayed(const Duration(seconds: 1));
      Get.offNamed(Routes.home);
    }
  }

  @override
  String get restorationId => Routes.login;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_autoValidateModeIndex, 'autovalidate_mode');
  }

  bool _obscureText = true;
  final RestorableInt _autoValidateModeIndex =
      RestorableInt(AutovalidateMode.disabled.index);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _nameFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    double iconPadding = (Helper.screenHeight / 2 - Helper.screenWidth / 3) / 2;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex.value],
      child: Scrollbar(
        child: SingleChildScrollView(
          restorationId: 'text_field_login_scroll_view',
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: iconPadding),
              Icon(
                Icons.insights,
                size: Helper.screenWidth / 4,
                color: Helper.imSurface,
              ),
              SizedBox(height: iconPadding - 30),
              TapRegion(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  child: Column(
                    children: [
                      //用户名
                      TextFormField(
                        restorationId: 'name_field',
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(fontSize: Helper.contentFontSize),
                        cursorColor: Helper.imSurface,
                        decoration: InputDecoration(
                          filled: true,
                          floatingLabelStyle:
                              TextStyle(color: Helper.imSurface),
                          contentPadding: const EdgeInsets.only(
                              top: 2, left: 10, right: 10),
                          errorStyle: const TextStyle(height: 0.3),
                          focusedBorder:
                              _buildOutlineInputBorder(Helper.imSurface),
                          focusedErrorBorder: _buildOutlineInputBorder(
                              Helper.themeManager.currentColorScheme.error),
                          enabledBorder:
                              _buildOutlineInputBorder(Helper.imSurface),
                          errorBorder: _buildOutlineInputBorder(
                              Helper.themeManager.currentColorScheme.error),
                          icon: const Icon(Icons.person),
                          hintText:
                              'loginRequirements'.tr.replaceAll("%s", "2"),
                          labelText: 'username'.tr,
                        ),
                        onSaved: (value) {
                          person.name = value;
                          _name.requestFocus();
                        },
                        validator: _validateName,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        restorationId: 'password_field',
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(fontSize: Helper.contentFontSize),
                        cursorColor: Helper.imSurface,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          filled: true,
                          floatingLabelStyle:
                              TextStyle(color: Helper.imSurface),
                          contentPadding: const EdgeInsets.only(
                              top: 2, left: 10, right: 10),
                          errorStyle: const TextStyle(height: 0.3),
                          focusedBorder:
                              _buildOutlineInputBorder(Helper.imSurface),
                          focusedErrorBorder: _buildOutlineInputBorder(
                              Helper.themeManager.currentColorScheme.error),
                          enabledBorder:
                              _buildOutlineInputBorder(Helper.imSurface),
                          errorBorder: _buildOutlineInputBorder(
                              Helper.themeManager.currentColorScheme.error),
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            hoverColor: Colors.transparent,
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText:
                              'loginRequirements'.tr.replaceAll("%s", "6"),
                          labelText: 'password'.tr,
                        ),
                        onSaved: (value) {
                          person.password = value;
                          _password.requestFocus();
                        },
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ) // your sub-tree that triggered the keyboard
                  ),
              RoundedLoadingButton(
                width: 100.r,
                color: Helper.imSurface,
                elevation: 0,
                borderRadius: 5.r,
                successColor: Helper.imSurface,
                valueColor: Helper.imPrimary,
                controller: _btnController,
                onPressed: _login,
                child: Text('login'.tr,
                    style: TextStyle(
                        fontSize: Helper.subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Helper.imPrimary)),
              )
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 0.5,
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'enterUsername'.tr;
    } else if (value.length < 2) {
      return 'usernameLengthError'.tr;
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'onlyAlphanumeric'.tr;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'enterPassword'.tr;
    } else if (value.length < 6) {
      return 'passwordLengthError'.tr;
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'onlyAlphanumeric'.tr;
    }
    return null;
  }
}
