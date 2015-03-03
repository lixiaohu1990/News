//
//  BMXinCaiFu.h
//  XinCaiFu
//
//  Created by Heidi on 13-8-22.
//  Copyright (c) 2013年 bluemobi. All rights reserved.
//

#ifndef XinCaiFu_BMXinCaiFu_h
#define XinCaiFu_BMXinCaiFu_h

#define WYISBLANK(value) [Utils isBlankString:value]

#define IMAGE_ADDRESS @"http://phpapi.ccjjj.net"

#define kINTERFACE_ADDRESS(addStr) [NSString stringWithFormat:@"http://phpapi.ccjjj.net/index.php/Api/%@",addStr]

//我的信息
#define MY_LOGIN  @"登录"
#define MY_LOGIN_API  kINTERFACE_ADDRESS(@"Member/login.html")
#define MY_LOGIN_PARAM  @"phone,password"

#define MY_GETCODE  @"获取验证码"
#define MY_GETCODE_API  kINTERFACE_ADDRESS(@"Member/sendchecknum.html")
#define MY_GETCODE_PARAM  @"phone"

#define MY_SIGN  @"用户注册"
#define MY_SIGN_API  kINTERFACE_ADDRESS(@"Member/reg.html")
#define MY_SIGN_PARAM  @"phone,telverify,password,nickname,sex,tuijian,cid"

#define MY_IDENTIFI  @"实名认证"
#define MY_IDENTIFI_API  kINTERFACE_ADDRESS(@"Member/realname.html")
#define MY_IDENTIFI_PARAM  @"uid,realname,company,email,position,type"

#define MY_MODIFYPW  @"修改密码"
#define MY_MODIFYPW_API  kINTERFACE_ADDRESS(@"Member/changepassword.html")
#define MY_MODIFYPW_PARAM  @"uid,old_password,new_password"

#define MY_MODIFYNAME  @"修改昵称"
#define MY_MODIFYNAME_API  kINTERFACE_ADDRESS(@"Member/changenickname.html")
#define MY_MODIFYNAME_PARAM  @"uid,new_nickname"

#define MY_PHONE  @"绑定手机"
#define MY_PHONE_API  kINTERFACE_ADDRESS(@"Member/phone.html")
#define MY_PHONE_PARAM  @"uid,phone"

#define MY_QUESTIONSLIST  @"我的提问列表"
#define MY_QUESTIONSLIST_API  kINTERFACE_ADDRESS(@"Member/myquestionlist.html")
#define MY_QUESTIONSLIST_PARAM  @"uid,pid,num"

#define MY_ANSWERSLIST  @"我的回答列表"
#define MY_ANSWERSLIST_API  kINTERFACE_ADDRESS(@"Member/myanswerlist.html")
#define MY_ANSWERSLIST_PARAM  @"uid,pid,num"

#define MY_ASKSLIST  @"追问我的列表"
#define MY_ASKSLIST_API  kINTERFACE_ADDRESS(@"Member/myanswerafterlist.html")
#define MY_ASKSLIST_PARAM  @"uid,pid,num"

#define MY_FANSSLIST  @"粉丝求助列表"
#define MY_FANSSLIST_API  kINTERFACE_ADDRESS(@"Member/fansquestionlist.html")
#define MY_FANSSLIST_PARAM  @"pid,num"

#define MY_MESSAGE  @"系统信息"
#define MY_MESSAGE_API  kINTERFACE_ADDRESS(@"Member/mymessagelist.html")
#define MY_MESSAGE_PARAM  @"uid"

#define MY_SETTING  @"消息设置"
#define MY_SETTING_API  kINTERFACE_ADDRESS(@"Member/setting.html")
#define MY_SETTING_PARAM  @"uid,isgetpush,isgethelp,iscomment,isafter,isadopt"

#define MY_FINDPW  @"找回密码"
#define MY_FINDPW_API  kINTERFACE_ADDRESS(@"Member/findpassword.html")
#define MY_FINDPW_PARAM  @"phone,telverify,new_password"

#define MY_ATTENTION  @"关注"
#define MY_ATTENTION_API  kINTERFACE_ADDRESS(@"Member/attention.html")
#define MY_ATTENTION_PARAM  @"uid,tuid"

#define MY_FANS  @"粉丝"
#define MY_FANS_API  kINTERFACE_ADDRESS(@"Member/fans.html")
#define MY_FANS_PARAM  @"uid"

#define MY_INTEREST  @"兴趣选择"
#define MY_INTEREST_API  kINTERFACE_ADDRESS(@"Member/interestadd.html")
#define MY_INTEREST_PARAM  @"uid,catid"

#define MY_GETINTEREST  @"获取兴趣分类"
#define MY_GETINTEREST_API  kINTERFACE_ADDRESS(@"Member/interestcategory.html")
#define MY_GETINTEREST_PARAM  @"uid"

#define MY_PRODUCT  @"我的物品"
#define MY_PRODUCT_API  kINTERFACE_ADDRESS(@"Member/myproduct.html")
#define MY_PRODUCT_PARAM  @"uid"

#define MY_GETRANK  @"获取会员等级"
#define MY_GETRANK_API  kINTERFACE_ADDRESS(@"Member/getrank.html")
#define MY_GETRANK_PARAM  @"uid"

#define MY_ATTENTIONLIST  @"获取关注信息"
#define MY_ATTENTIONLIST_API  kINTERFACE_ADDRESS(@"Member/attentionlist.html")
#define MY_ATTENTIONLIST_PARAM  @"uid"

#define MY_MEMEBERINFO  @"获取会员的基本信息"
#define MY_MEMEBERINFO_API  kINTERFACE_ADDRESS(@"Member/memberinfo.html")
#define MY_MEMEBERINFO_PARAM  @"uid"

//广告
#define AD_INFO  @"获取广告位"
#define AD_INFO_API  kINTERFACE_ADDRESS(@"Ad/getad.html")
#define AD_INFO_PARAM  @"catid"

//系统信息接口
#define SYSTEMS_INFO  @"获取系统所有信息列表"
#define SYSTEMS_INFO_API  kINTERFACE_ADDRESS(@"Message/messagelist.html")
#define SYSTEMS_INFO_PARAM  @"uid,pid,num"
//
//#define SYSTEM_SHOW  @"查看系统信息"
//#define SYSTEM_SHOW_API  kINTERFACE_ADDRESS(@"Message/showmessage.html")
//#define SYSTEM_SHOW_PARAM  @"uid,id"
//
//#define SYSTEM_SHOW  @"查看系统信息"
//#define SYSTEM_SHOW_API  kINTERFACE_ADDRESS(@"Message/showmessage.html")
//#define SYSTEM_SHOW_PARAM  @"uid,id"
#define SYSTEM_INFO  @"获取试验圈动态"
#define SYSTEM_INFO_API  kINTERFACE_ADDRESS(@"Message/getnews.html")
#define SYSTEM_INFO_PARAM  @"uid,pid,num"

//回答接口
#define ANSWER_INFO  @"获取回答列表"
#define ANSWER_INFO_API  kINTERFACE_ADDRESS(@"Answer/answerlist.html")
#define ANSWER_INFO_PARAM  @"pid,num,qid"

#define ADD_QUES_LIST  @"获取追问列表"
#define ADD_QUES_LIST_API  kINTERFACE_ADDRESS(@"Answer/answerafterlist.html")
#define ADD_QUES_LIST_PARAM  @"aid,pid,num"

#define ANSWER_ADD  @"添加回答"
#define ANSWER_ADD_API  kINTERFACE_ADDRESS(@"Answer/answeradd.html")
#define ANSWER_ADD_PARAM  @"uid,id,type,content"

#define ANSWER_ADDQUES  @"添加追问"
#define ANSWER_ADDQUES_API  kINTERFACE_ADDRESS(@"Answer/answerafter.html")
#define ANSWER_ADDQUES_PARAM  @"uid,qid,aid,content"

#define ANSWER_ADOPT  @"采纳答案"
#define ANSWER_ADOPT_API  kINTERFACE_ADDRESS(@"Answer/adopt.html")
#define ANSWER_ADOPT_PARAM  @"uid,aid"

#define ANSWER_COUN  @"获取问题的回答数"
#define ANSWER_COUNT_API  kINTERFACE_ADDRESS(@"Answer/getanswernum.html")
#define ANSWER_COUNT_PARAM  @"uid,qid"

#define ANSWER_ZHUIWEN_COUNT  @"获取问题的追问数"
#define ANSWER_ZHUIWEN_COUNT_API  kINTERFACE_ADDRESS(@"Answer/getafternum.html")
#define ANSWER_ZHUIWEN_COUNT_PARAM  @"uid,qid"

#define ANSWER_SUPPORT_COUNT  @"获取问题的支持数"
#define ANSWER_SUPPORT_COUNT_API  kINTERFACE_ADDRESS(@"Answer/getsupportnum.html")
#define ANSWER_SUPPORT_COUNT_PARAM  @"uid,aid"

#define ANSWER_ADD_SUPPORT  @"添加支持"
#define ANSWER_ADD_SUPPORT_API  kINTERFACE_ADDRESS(@"Answer/support.html")
#define ANSWER_ADD_SUPPORT_PARAM  @"uid,aid"

#define ANSWER_SUPPORT_LIST  @"获取支持者列表"
#define ANSWER_SUPPORT_LIST_API  kINTERFACE_ADDRESS(@"Answer/supportlist.html")
#define ANSWER_SUPPORT_LIST_PARAM  @"uid,aid"


//提问接口
#define QUESTIONS_LIST  @"获取问题列表"
#define QUESTIONS_LIST_API  kINTERFACE_ADDRESS(@"Question/questionlist.html")
#define QUESTIONS_LIST_PARAM  @"pid,num"

#define QUESTIONS_ADD  @"发布问题"
#define QUESTIONS_ADD_API  kINTERFACE_ADDRESS(@"Question/questionadd.html")
#define QUESTIONS_ADD_PARAM  @"uid,catid,content,lable,reward,superlist,image"

#define QUESTIONS_DELETE  @"删除问题"
#define QUESTIONS_DELETE_API  kINTERFACE_ADDRESS(@"Question/questiondel.html")
#define QUESTIONS_DELETE_PARAM  @"uid,qid"

#define QUESTIONS_CATA  @"获取栏目列表"
#define QUESTIONS_CATA_API  kINTERFACE_ADDRESS(@"Question/categorylist.html")
#define QUESTIONS_CATA_PARAM  @"id"

#define QUESTIONS_SUPPORT  @"添加支持"
#define QUESTIONS_SUPPORT_API  kINTERFACE_ADDRESS(@"Question/support.html")
#define QUESTIONS_SUPPORT_PARAM  @"uid,qid"

#define QUESTIONS_SEAR  @"搜索问题"
#define QUESTIONS_SEAR_API  kINTERFACE_ADDRESS(@"Question/search.html")
#define QUESTIONS_SEAR_PARAM  @"pid,num,keyword"

#define QUESTIONS_SUPPORTLIST  @"获取支持着列表"
#define QUESTIONS_SUPPORTLIST_API  kINTERFACE_ADDRESS(@"Question/supportlist.html")
#define QUESTIONS_SUPPORTLIST_PARAM  @"uid,qid"

#define QUESTIONS_GAOLIST  @"获取高手列表"
#define QUESTIONS_GAOLIST_API  kINTERFACE_ADDRESS(@"Question/supperlist.html")
#define QUESTIONS_GAOLIST_PARAM  @"uid"

#define QUESTIONS_JUBAO  @"添加举报"
#define QUESTIONS_JUBAO_API  kINTERFACE_ADDRESS(@"Question/report.html")
#define QUESTIONS_JUBAO_PARAM  @"uid,qid"

#define QUESTIONS_SELECT  @"筛选问题"
#define QUESTIONS_SELECT_API  kINTERFACE_ADDRESS(@"Question/select.html")
#define QUESTIONS_SELECT_PARAM  @"pid,num,catid,isreward,issolveed"

//礼品接口
#define PRODUC_LIST  @"获取礼品列表"
#define PRODUC_LIST_API  kINTERFACE_ADDRESS(@"Product/productlist.html")
#define PRODUC_LIST_PARAM  @"uid,pid,num,type"

#define PRODUC_INFO  @"获取礼品信息"
#define PRODUC_INFO_API  kINTERFACE_ADDRESS(@"Product/getshow.html")
#define PRODUC_INFO_PARAM  @"uid,proid"

#define PRODUC_CH  @"礼品兑换"
#define PRODUC_CH_API  kINTERFACE_ADDRESS(@"Product/recharge.html")
#define PRODUC_CH_PARAM  @"uid,proid,name,phone,address,email,company"

#define PRODUC_CHINFO  @"查看礼品兑换信息"
#define PRODUC_CHINFO_API  kINTERFACE_ADDRESS(@"Product/rechargeinfo.html")
#define PRODUC_CHINFO_PARAM  @"uid,proid"

#define PRODUC_STUDY  @"获取学习资料"
#define PRODUC_STUDY_API  kINTERFACE_ADDRESS(@"Product/getlearn.html")
#define PRODUC_STUDY_PARAM  @"uid"


//发现接口
#define FIND_BAO  @"获取助手日报"
#define FIND_BAO_API  kINTERFACE_ADDRESS(@"Found/daily.html")
#define FIND_BAO_PARAM  @"pid,num"

#define FIND_KAN  @"获取试验周刊"
#define FIND_KAN_API  kINTERFACE_ADDRESS(@"Found/weekly.html")
#define FIND_KAN_PARAM  @"pid,num"

#define FIND_XIAN  @"获取法规文献"
#define FIND_XIAN_API  kINTERFACE_ADDRESS(@"Found/documents.html")
#define FIND_XIAN_PARAM  @"pid,num"

#define FIND_ACT  @"获取活动中心"
#define FIND_ACT_API  kINTERFACE_ADDRESS(@"Found/party.html")
#define FIND_ACT_PARAM  @"pid,num"

#define FIND_TEACH  @"获取培训信息"
#define FIND_TEACH_API  kINTERFACE_ADDRESS(@"Found/train.html")
#define FIND_TEACH_PARAM  @"pid,num"

#define FIND_BRAND  @"获取品牌信息"
#define FIND_BRAND_API  kINTERFACE_ADDRESS(@"Found/brands.html")
#define FIND_BRAND_PARAM  @"pid,num"

#define FIND_ARTICLE  @"查看文章信息"
#define FIND_ARTICLE_API  kINTERFACE_ADDRESS(@"Found/show.html")
#define FIND_ARTICLE_PARAM  @"id,type"

#define FIND_ENTER  @"我要报名"
#define FIND_ENTER_API  kINTERFACE_ADDRESS(@"Found/registration.html")
#define FIND_ENTER_PARAM  @"uid,catid,name,phone,email,company"

#define FIND_SEARCH  @"搜索"
#define FIND_SEARCH_API  kINTERFACE_ADDRESS(@"Found/search.html")
#define FIND_SEARCH_PARAM  @"pid,num,catid,keyword"

#define FIND_ADD  @"添加讨论"
#define FIND_ADD_API  kINTERFACE_ADDRESS(@"Found/discussadd.html")
#define FIND_ADD_PARAM  @"uid,id,content"

#define FIND_DISCUSS  @"获取讨论列表"
#define FIND_DISCUSS_API  kINTERFACE_ADDRESS(@"Found/discusslist.html")
#define FIND_DISCUSS_PARAM  @"pid,num,id"

#define FIND_HIT  @"点赞"
#define FIND_HIT_API  kINTERFACE_ADDRESS(@"Found/hit.html")
#define FIND_HIT_PARAM  @"uid,did"

#define FIND_SURVERY  @"获取调查问卷"
#define FIND_SURVERY_API  kINTERFACE_ADDRESS(@"Found/questionnairelist.html")
#define FIND_SURVERY_PARAM  @"pid,num,catid"

#define FIND_SURVERYADD  @"问卷提交"
#define FIND_SURVERYADD_API  kINTERFACE_ADDRESS(@"Found/questionnaireadd.html")
#define FIND_SURVERYADD_PARAM  @"uid,options"

//统计接口
#define HIS_HITS  @"获取点赞数"
#define HIS_HITS_API  kINTERFACE_ADDRESS(@"Tongji/gethits.html")
#define HIS_HITS_PARAM  @"uid,did"

#define HIS_ATTENT  @"获取我的关注数"
#define HIS_ATTENT_API  kINTERFACE_ADDRESS(@"Tongji/getattentionnum.html")
#define HIS_ATTENT_PARAM  @"uid"

#define HIS_TIWEN  @"获取我的提问数"
#define HIS_TIWEN_API  kINTERFACE_ADDRESS(@"Tongji/getquestionnum.html")
#define HIS_TIWEN_PARAM  @"uid"

#define HIS_ANS  @"获取我的回答数"
#define HIS_ANS_API  kINTERFACE_ADDRESS(@"Tongji/getanswernum.html")
#define HIS_ANS_PARAM  @"uid"

#define HIS_TAKE  @"获取回答采纳数"
#define HIS_TAKE_API  kINTERFACE_ADDRESS(@"Tongji/getadoptnum.html")
#define HIS_TAKE_PARAM  @"uid,auid"

#define HIS_RANK  @"获取正解排行榜"
#define HIS_RANK_API  kINTERFACE_ADDRESS(@"Tongji/getadoptranklist.html")
#define HIS_RANK_PARAM  @"uid,type"

#define HIS_RANKSU  @"获取回答排行榜"
#define HIS_RANKSU_API  kINTERFACE_ADDRESS(@"Tongji/getanswerranklist.html")
#define HIS_RANKSU_PARAM  @"uid,type"

#define HIS_NUM  @"获取我发布问题的追问数"
#define HIS_NUM_API  kINTERFACE_ADDRESS(@"Tongji/getafternum.html")
#define HIS_NUM_PARAM  @"uid,qid"

#define MY_ID  @"我的助手ID"
#define MY_ID_API  kINTERFACE_ADDRESS(@"Member/assistantinfo.html")
#define MY_ID_PARAM  @"uid"

#define FEEDBACK  @"意见反馈"
#define FEEDBACK_API  kINTERFACE_ADDRESS(@"Member/feedback.html")
#define FEEDBACK_PARAM  @"uid,content"

#define ZJ  @"获取正解排行榜"
#define ZJ_API  kINTERFACE_ADDRESS(@"Tongji/getadoptranklist.html")
#define ZJ_PARAM  @"uid,type"

#define HD  @"获取回答排行榜"
#define HD_API  kINTERFACE_ADDRESS(@"Tongji/getanswerranklist.html")
#define HD_PARAM  @"uid,type"

#define ZS  @"t获取助手红人排行榜"
#define ZS_API  kINTERFACE_ADDRESS(@"Tongji/invitationranklist.html")
#define ZS_PARAM  @"uid,type"

#define LIN_QU  @"绑领取任务"
#define LIN_QU_API  kINTERFACE_ADDRESS(@"Member/submittask.html")
#define LIN_Qu_PARAM  @"uid,type"
#endif
