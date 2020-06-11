package com.taskrabbit.zendesk;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.res.Configuration;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import java.lang.String;
import java.util.Locale;

import zendesk.chat.Chat;
import zendesk.chat.ChatConfiguration;
import zendesk.chat.ChatEngine;
import zendesk.chat.ChatProvider;
import zendesk.chat.ProfileProvider;
import zendesk.chat.VisitorInfo;
import zendesk.messaging.MessagingActivity;

public class RNZendeskChatModule extends ReactContextBaseJavaModule {
    private ReactContext mReactContext;

    public RNZendeskChatModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNZendeskChatModule";
    }

    @ReactMethod
    public void setVisitorInfo(ReadableMap options) {
        ProfileProvider profileProvider = Chat.INSTANCE.providers().profileProvider();
        ChatProvider chatProvider = Chat.INSTANCE.providers().chatProvider();
        VisitorInfo.Builder builder = VisitorInfo.builder();
        if (options.hasKey("name")) {
            builder.withName(options.getString("name"));
        }
        if (options.hasKey("email")) {
            builder.withEmail(options.getString("email"));
        }
        if (options.hasKey("phone")) {
            builder.withPhoneNumber(options.getString("phone"));
        }
        profileProvider.setVisitorInfo(
                builder.build(),
                null
        );
        if (options.hasKey("department")) {
            chatProvider.setDepartment(options.getString("department"), null);
        }
    }

    @ReactMethod
    public void init(String key) {
        Chat.INSTANCE.init(mReactContext, key);
    }

    @ReactMethod
    public void startChat(ReadableMap options) {
        setVisitorInfo(options.getMap("user"));
        ChatConfiguration chatConfiguration = ChatConfiguration.builder()
                .build();
        Activity activity = getCurrentActivity();
        if (activity != null) {

            ReadableMap uiSetting = options.getMap("uiSetting");
            Context context = new ContextWrapper(activity);
            MessagingActivity.builder().
                    withEngines(ChatEngine.engine())
                    .show(context, chatConfiguration);
        }
    }
}
