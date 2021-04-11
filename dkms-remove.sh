#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  if [[ "$LANG" == "zh_CN.UTF-8" ]]; then
    echo "您必须使用超级用户权限运行。可以尝试：\"sudo ./dkms-remove.sh\"" 2>&1
  else
    echo "You must run this with superuser priviliges.  Try \"sudo ./dkms-remove.sh\"" 2>&1
  fi
  exit 1
else
  if [[ "$LANG" == "zh_CN.UTF-8" ]]; then
    echo "即将执行dkms的删除步骤..."
  else
    echo "About to run dkms removal steps..."
  fi
fi

DRV_NAME=rtl8192fu
DRV_VERSION=v5.8.6.2_35538.20191028

dkms remove ${DRV_NAME}/${DRV_VERSION} --all
rm -rf /usr/src/${DRV_NAME}-${DRV_VERSION}

RESULT=$?
if [[ "$RESULT" != "0" ]]; then
  if [[ "$LANG" == "zh_CN.UTF-8" ]]; then
    echo "运行dkms remove时发生错误。" 2>&1
  else
    echo "Error occurred while running dkms remove." 2>&1
  fi
else
  if [[ "$LANG" == "zh_CN.UTF-8" ]]; then
    echo "完成运行dkms的删除步骤。"
  else
    echo "Finished running dkms removal steps."
  fi
fi

exit $RESULT
