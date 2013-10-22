# Source in Fusion global variables.
. !!osb.file.profiledir!!/enterprise/fusion_global.profile
export SUB_AREA=hr
export DOMAIN_NAME=!!osb.domain!!

# Source in user specific variables:
export STIME=60

export FTP_PROP_DIR=com/nike/${SUB_AREA}/ftp/properties
export FTP_CONFIG_DIR=com/nike/${SUB_AREA}/ftp/config
export FTP_LOG_DIR=!!osb.file.logdir!!/application/${SUB_AREA}/ftp

export SCRIPTS_LOG_DIR=!!osb.file.logdir!!/application/${SUB_AREA}/scripts
export SCRIPTS_DIR=!!osb.file.appdir!!/${SUB_AREA}

export BFP_CONF_DIR=!!osb.file.confdir!!/com/nike/${SUB_AREA}/bfp/properties
export BFP_SCRIPT_DIR=!!osb.file.confdir.enterprise!!/bfp

export CONF_DIR=!!osb.file.confdir!! 
export DATA_DIR=!!osb.file.datadir!!

export AUTOSYS_JMS_HOST=!!osb.autosys.response.host!!
export AUTOSYS_JMS_PORT=!!osb.autosys.response.port!!

export JMS_PROP_DIR=com/nike/${SUB_AREA}/jmsClient/properties

# Source in user specific variables:

#SAP
export SAP_USER_NAME=!!osb.ftp.hr.sap.user!!
export FTP_HOST_SAP=!!osb.ftp.hr.sap.host!!
export HRSAP_ROOT_DIR=!!osb.ftp.hr.sap.rootdir!!


#EMFT
export FTP_HOST_EMFT=!!osb.ftp.hr.emft.host!!
export EMFT_USER_NAME=!!osb.ftp.hr.emft.user!!
export EMFT_PORT_NUMBER=!!osb.ftp.hr.emft.port!!
export EMFT_ROOT_DIR=!!osb.ftp.hr.emft.rootdir!!

#HR ARCHIVE
export FTP_HOST_HR_ARCHIVE=!!osb.ftp.hr.archive.host!!
export HR_ARCHIVE_USER_NAME=!!osb.ftp.hr.archive.user!!
export HR_ARCHIVE_DIR=!!osb.ftp.hr.archive.rootdir!!
export ARCHIVE_ENV_DIR=!!osb.ftp.hr.archive.envdir!!

#I110
export FTP_HOST_NKE_RTL_STRE=!!osb.ftp.hr.retailstore.host!!
export NKE_RTL_STRE_USER_NAME=!!osb.ftp.hr.retailstore.user!!
export NKE_RTL_STRE_DATA_DIR=!!osb.ftp.hr.retailstore.rootdir!!

#I108
export FTP_HOST_NKE_EMPL_STRE=!!osb.ftp.hr.empstore.host!!
export NKE_EMPL_STRE_USER_NAME=!!osb.ftp.hr.empstore.user!!
export NKE_EMPL_STRE_DATA_DIR=!!osb.ftp.hr.empstore.rootdir!!

#I159
export FTP_HOST_NKE_ACTIVE_DIR=!!osb.ftp.hr.nikeAD.host!!
export NKE_ACTIVE_DIR_USER_NAME=!!osb.ftp.hr.nikeAD.user!!
export NIKE_ACTIVE_DIR=!!osb.ftp.hr.nikeAD.rootdir!!

#I195
export FTP_HOST_USA_WFM_NIKERETAIL=!!osb.ftp.hr.usawfm.host!!
export USA_WFM_NIKERETAIL_USER_NAME=!!osb.ftp.hr.usawfm.user!!
export USA_WFM_NIKERETAIL_DATA_DIR=!!osb.ftp.hr.usawfm.rootdir!!

export FTP_HOST_USA_GTLA=!!osb.ftp.hr.usagtla.host!!
export USA_GTLA_USER_NAME=!!osb.ftp.hr.usagtla.user!!
export USA_GTLA_DATA_DIR=!!osb.ftp.hr.usagtla.rootdir!!

export FTP_HOST_GBR_GTLA=!!osb.ftp.hr.gbrgtla.host!!
export GBR_GTLA_USER_NAME=!!osb.ftp.hr.gbrgtla.user!!
export GBR_GTLA_DATA_DIR=!!osb.ftp.hr.gbrgtla.rootdir!!

export FTP_HOST_CAN_GTLA=!!osb.ftp.hr.cangtla.host!!
export CAN_GTLA_USER_NAME=!!osb.ftp.hr.cangtla.user!!
export CAN_GTLA_DATA_DIR=!!osb.ftp.hr.cangtla.rootdir!!

export FTP_HOST_FRA_GTLA=!!osb.ftp.hr.fragtla.host!!
export FRA_GTLA_USER_NAME=!!osb.ftp.hr.fragtla.user!!
export FRA_GTLA_DATA_DIR=!!osb.ftp.hr.fragtla.rootdir!!

export FTP_HOST_SEA_GTLA=!!osb.ftp.hr.seagtla.host!!
export SEA_GTLA_USER_NAME=!!osb.ftp.hr.seagtla.user!!
export SEA_GTLA_DATA_DIR=!!osb.ftp.hr.seagtla.rootdir!!

export FTP_HOST_CHN_GTLA=!!osb.ftp.hr.chngtla.host!!
export CHN_GTLA_USER_NAME=!!osb.ftp.hr.chngtla.user!!
export CHN_GTLA_DATA_DIR=!!osb.ftp.hr.chngtla.rootdir!!

#BOA- I272
export FTP_HOST_BOA=!!osb.ftp.hr.boa.host!!
export BOA_CHECK_CLEARING_USER_NAME=!!osb.ftp.hr.boa.user!!
export BOA_CHECK_CLEARING_DIR=!!osb.ftp.hr.boa.rootdir!!

#I079
export BOA_DIRECT_DEPOSIT_ACH_USER_NAME=!!osb.ftp.hr.boa.directdeposit.user!!
export BOA_DIRECT_DEPOSIT_ACH_DIR=!!osb.ftp.hr.boa.directdeposit.rootdir!!

#I087
export BOA_POSITIVE_PAY_USER_NAME=!!osb.ftp.hr.boa.positivepay.user!!
export BOA_POSITIVE_PAY_DIR=!!osb.ftp.hr.boa.positivepay.rootdir!!

#I127
export FTP_HOST_NAG=!!osb.ftp.hr.jpn-nag.host!!
export NAG_USER_NAME=!!osb.ftp.hr.jpn-nag.user!!
export NAG_DATA_DIR=!!osb.ftp.hr.jpn-nag.rootdir!!
export NAG_PORT_NUMBER=!!osb.ftp.hr.jpn-nag.port!!

#I183 -Empty_file
export CM_SAL_56_EMPTYFILE_OUTPUT_DIR=/${SUB_AREA}/CM/GBL/out

#SAPHCM
export SAP_AD_PORTAL_INPUT_DIR=!!osb.file.datadir!!/${SUB_AREA}/PA/GBL/in
export SAP_AD_COMMON_SERVICE=!!osb.http.loadbalancer.hostname!!
export SAP_AD_COMMON_SERVICE_PORT=!!osb.http.loadbalancer.port!!
export SAP_AD_EMAIL_SERVER=!!osb.email.server.hostname!!
export SAP_AD_LDAP_PORT=!!osb.ldap.server.port!!
export SAP_AD_LDAP_SERVER=!!osb.ldap.server.hostname!!
export SAP_AD_LDAP_USER=!!osb.ldap.hr.username!!
export SAP_AD_LDAP_PASSWORD=!!osb.ldap.hr.password!!
export SAP_AD_LDAP_BASEDN=!!osb.ldap.hr.basedn!!
export SAPHCM_TO_AD_SYNC_LIB_DIR=!!osb.hr.saphcmadsync.lib.dir!!
export SAPHCM_TO_AD_SYNC_JAR_DIR=!!osb.hr.saphcmadsync.jar.dir!!
export SAPHCM_TO_AD_SYNC_CONFIG_DIR=!!osb.file.confdir!!


SAPHCM_TO_AD_SYNC_CLASSPATH=${SAPHCM_TO_AD_SYNC_CONFIG_DIR}:${SAPHCM_TO_AD_SYNC_JAR_DIR}/SAPHCMToADSync.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/CommonServicesClient.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/CommonUtil.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/LDAPUtil.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/axis.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/commons-discovery-0.2.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/CommonServicesClient.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/FileUtil.jar:$SAPHCM_TO_AD_SYNC_LIB_DIR/javamail.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/javax.wsdl_1.5.1.v201005080630.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/jaxrpc.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/org.apache.commons.logging_1.0.4.v201005080501.jar:${SAPHCM_TO_AD_SYNC_LIB_DIR}/saaj.jar

export SAPHCM_TO_AD_SYNC_CLASSPATH

PATH=$PATH:${SCRIPTS_DIR}:${BFP_SCRIPT_DIR}
export PATH
