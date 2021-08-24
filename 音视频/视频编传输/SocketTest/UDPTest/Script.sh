#!/bin/sh

#  Script.sh
#  UDPTest
#
#  Created by mac on 2017/12/19.
#  Copyright © 2017年 mac. All rights reserved.

HEAD_FILE="$PROJECT_DIR/$PROJECT_NAME/DefaultString.h"
export LC_CTYPE=C

touch $HEAD_FILE
echo '#ifndef DefaultString_h \\\
      #define DefaultString_h' >> $HEAD_FILE

echo '#define qqqqq "function_1"' >> $HEAD_FILE

echo "#endif" >> $HEAD_FILE

