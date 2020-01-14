/// 
Class od.DetectObjects Extends (Ens.BusinessProcessBPL)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='od.msg.ImageODRequest' response='od.msg.ImageODResponse' height='2000' width='2000' >
<context>
<property name='ObjectsAsString' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='exportableDF' type='%String' collection='array' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='listDF' type='%String' collection='list' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='status' type='%Integer' collection='array' instantiate='0' />
<property name='resultName' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='250' />
</parameters>
</property>
</context>
<sequence xend='200' yend='1050' >
<call name='Send Value To Python' target='od.BO.PythonGateway' async='1' xpos='200' ypos='250' >
<request type='Ens.Request' >
<assign property="callrequest.Code" value="&quot;sample_image_path = r'&quot;_request.Filepath_&quot;/&quot;_request.Filename_&quot;'&quot;" action="set" />
<assign property="callrequest.Variables" value="&quot;sample_image_path&quot;" action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync calls='Send Value To Python' type='all' xpos='200' ypos='350' />
<call name='Detect Objects' target='od.BO.PythonGateway' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[import os
from pprint import pprint
from six import BytesIO
from collections import namedtuple
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import tEnsorflow.compat.v1 as tf
import tEnsorflow_hub as hub
from PIL import Image, ImageColor, ImageDraw, ImageFont, ImageOps
from tqdm import tqdm
import time
import sys
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2' 
tf.disable_v2_behavior()
tf.get_logger().setLevel('WARNING')
tf.autograph.set_verbosity(2)
sys.path.append(r'/home/irisuser/pycode')
import od_utils
import od_detectf

resultOut = od_detectf.detect_image(sample_image_path)
result=resultOut['result']
image_out=resultOut['image']
]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Detect Objects&quot;)" action="set" />
<assign property="callrequest.Variables" value="&quot;result&quot;" action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync calls='Detect Objects' type='all' xpos='200' ypos='550' />
<call name='Prepare Results' target='od.BO.PythonGateway' async='1' xpos='200' ypos='650' >
<annotation><![CDATA[resultDF=pd.DataFrame(od_utils.TFtoPANDAS(result))
resultDF=resultDF.loc[resultDF.reset_index().groupby(['objectID'])['Score'].idxmax()]
resultDF=resultDF[resultDF['Class']!=b'Shelf']
exportableDF=resultDF[resultDF['Score']>0.2].to_json(orient='records')
exportableDF='{"objects":'+exportableDF+'}']]></annotation>
<request type='Ens.Request' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Prepare Results&quot;)" action="set" />
<assign property="callrequest.Variables" value="&quot;exportableDF&quot;" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response.JSONResponse" value="callresponse.Variables.GetAt(&quot;exportableDF&quot;)" action="set" />
</response>
</call>
<sync calls='Prepare Results' type='all' xpos='200' ypos='750' />
<call name='Annotate Image' target='od.BO.PythonGateway' async='1' xpos='200' ypos='850' >
<annotation><![CDATA[image_with_boxes = od_utils.draw_boxes(np.array(image_out), resultDF[['Ymin','Xmin','Ymax','Xmax']].to_numpy(),resultDF['Class'].to_numpy(), resultDF['Score'].to_numpy(), max_boxes=100, min_score=0.2)
im = Image.fromarray(image_with_boxes)
import random
ran=random.randint(100,999)
im.save("/usr/irissys/csp/python/result"+str(ran)+".jpg")]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Annotate Image&quot;)" action="set" />
<assign property="callrequest.Variables" value="&quot;ran&quot;" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response.resultFile" value="&quot;result&quot;_callresponse.Variables.GetAt(&quot;ran&quot;)_&quot;.jpg&quot;" action="set" />
</response>
</call>
<sync calls='Annotate Image' type='all' xpos='200' ypos='950' />
</sequence>
</process>
}

}
