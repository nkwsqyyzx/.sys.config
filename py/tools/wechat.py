#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
    wechat.py

    Use to contact with wechat such as sending messages
    :copyright: (c) 2022 by nkwsqyyzx@gmail.com
    :license: BSD, see LICENSE for more details.
"""
import json

import requests


def _json(text):
    try:
        return json.loads(text)
    except ValueError:
        return {}


class Tool(object):
    """
    Tool class for static methods.
    """

    @staticmethod
    def update_access_token(corp_id, corp_secret):
        """
        更新access_token，参考微信官方文档
        :param corp_id:
        :param corp_secret:
        :return:
        """

        url = 'https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid={}&corpsecret={}'.format(corp_id, corp_secret)
        r = requests.get(url)
        res = _json(r.text)
        return res.get('access_token') or ''

    @staticmethod
    def send_text_to_user(access_token, agent_id, user, message):
        """
        给单个用户发消息，参考微信官方文档
        :param access_token:
        :param agent_id:
        :param user:
        :param message:
        :return:
        """

        url = 'https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token={}'.format(access_token)
        data = {
            "touser": user,
            "toparty": "",
            "totag": "",
            "msgtype": "text",
            "agentid": int(agent_id),
            "text": {
                "content": message,
            },
            "safe": 0,
            "enable_id_trans": 0,
            "enable_duplicate_check": 0
        }
        r = requests.post(url, json=data)
        res = _json(r.text)
        errmsg = res.get('errmsg', 'ok')
        return errmsg


def robot_send_text(secret: str, content: str):
    """
    usage: call_python_function.py ~/.sys.config/py/tools/ wechat.robot_send_text [secret] [content]
    :param secret:  微信自定义机器人
    :param content:  消息文本
    :return:
    """
    msg = {
        'msgtype': 'text',
        'text': {'content': content},
    }

    headers = {"Content-Type": "application/json;charset=utf-8"}
    url = 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=' + secret
    body = json.dumps(msg)
    res = requests.post(url, data=body, headers=headers, timeout=10)
    r = res.json()
    if r['errcode'] != 0:
        raise Exception(f'{r}')
