#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  if [[ "$LANG" == "zh_CN.UTF-8" ]]; then
    echo "您必须使用超级用户权限运行。可以尝试：\"sudo ./dkms-install.sh\"" 2>&1
  else
    echo "You must run this with superuser priviliges.  Try \"sudo ./dkms-install.sh\"" 2>&1
  fi
  exit 1
else
  if [[ "$LANG" == "zh_CN.UTF-8" ]]; then
    echo "即将执行dkms的安装步骤..."
  else
    echo "About to run dkms install steps..."
  fi
fi

DRV_NAME=rtl8192fu
DRV_VERSION=v5.8.6.2_35538.20191028

cp -r . /usr/src/${DRV_NAME}-${DRV_VERSION}

dkms add -m ${DRV_NAME} -v ${DRV_VERSION}
dkms build -m ${DRV_NAME} -v ${DRV_VERSION}
dkms install -m ${DRV_NAME} -v ${DRV_VERSION}
RESULT=$?

if [[ "$LANG" == "zh_CN.UTF-8" ]]; then
  echo "完成运行dkms的安装步骤。"
else
  echo "Finished running dkms install steps."
fi

exit $RESULT
