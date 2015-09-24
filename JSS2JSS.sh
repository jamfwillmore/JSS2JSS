#!/bin/bash
####################################################################################################
#
# Copyright (c) 2015, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#############################################################



##################WARNING TO USER
osascript -e 'Tell application "System Events" to display dialog "This will move OS X Policies,Smart Groups, Categories and Configuration Profiles, it will remove Scope" buttons {"Cancel", "Continue"} cancel button "Cancel" default button "Continue" with icon caution'

####VARIABLES


######## Asks for Variable for old JSS address
oldjss="$(osascript -e 'Tell application "System Events" to display dialog "Enter OLD JSS Address with no Trailing Slash:" default answer "https://yourjssaddress.com:8443"' -e 'text returned of result' 2>/dev/null)"
if [ $? -ne 0 ]; then
   # The user pressed Cancel
    exit 1 # exit with an error status
elif [ -z "$oldjss" ]; then
    # The user left the project name blank
   osascript -e 'Tell application "System Events" to display alert "You must enter a JSS Address; cancelling..." as warning'
    exit 1 # exit with an error status
fi

######## asks for new JSS Address and adds variable
newjss="$(osascript -e 'Tell application "System Events" to display dialog "Enter NEW JSS Address no trailing slash:" default answer "https://yourjssaddress.com:8443"' -e 'text returned of result' 2>/dev/null)"
if [ $? -ne 0 ]; then
    # The user pressed Cancel
    exit 1 # exit with an error status
elif [ -z "$newjss" ]; then
    # The user left the project name blank
    osascript -e 'Tell application "System Events" to display alert "You must enter a JSS Address; cancelling..." as warning'
    exit 1 # exit with an error status
fi


############## asks for user for API and adds variable
apiuser="$(osascript -e 'Tell application "System Events" to display dialog "Enter API username: have same account on both JSS:" default answer ""' -e 'text returned of result' 2>/dev/null)"
if [ $? -ne 0 ]; then
    # The user pressed Cancel
    exit 1 # exit with an error status
elif [ -z "$apiuser" ]; then
    # The user left the project name blank
    osascript -e 'Tell application "System Events" to display alert "You must enter a JSS Address; cancelling..." as warning'
    exit 1 # exit with an error status
fi

######### asks for password for API users and adds variable
apipass="$(osascript -e 'Tell application "System Events" to display dialog "Enter API Password: have same account on both JSS:" default answer "" with hidden answer' -e 'text returned of result' 2>/dev/null)"
if [ $? -ne 0 ]; then
    # The user pressed Cancel
    exit 1 # exit with an error status
elif [ -z "$apipass" ]; then
    # The user left the project name blank
    osascript -e 'Tell application "System Events" to display alert "You must enter a JSS Address; cancelling..." as warning'
    exit 1 # exit with an error status
fi

#######manual variables
#oldjss="https://yourjss.com:8443"
#apiuser="username"
#apipass="password"
#newjss="https://newjss.com:8443"



########### the 1 and then the second number is how many id's it will look through if you have more than 45 change 45 to one higher then you have
#for i in {1..50}
#do



##############################################
######
#######   DO NOT CHANGE BELOW THIS LINE!!!!!!
######
######
#################################################


#####moving Computers Records Over

####### Download Computers to XML file from old JSS  ###############################################################
for i in {1..50}    ######for the i make the second number match the highest number id you have
do

curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/computers/id/$i > /tmp/computers.xml



####### upload xml file into new JSS for computer records
curl -k -s -u $apiuser:$apipass $newjss/JSSResource/computers/id/$i -T /tmp/computers.xml -X POST
done

#######Moving Departments from old JSS to new JSS ###############################################################


for i in {1..50}
do
#########Download depts from old JSS to xml file
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/departments/id/$i > /tmp/dept.xml

############upload depts from XML to new JSS
curl -k -s -u $apiuser:$apipass $newjss/JSSResource/departments/id/$i -T /tmp/dept.xml -X POST

done

#######Moving buildings from old JSS to new JSS ###############################################################


for i in {1..75}
do
#########Download Buildings from old JSS to xml file
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/buildings/id/$i > /tmp/bld.xml

############upload Buildings from XML to new JSS
curl -k -s -u $apiuser:$apipass $newjss/JSSResource/buildings/id/$i -T /tmp/bld.xml -X POST
done

#######Moving network segments from old JSS to new JSS ###############################################################


for i in {1..400}
do
#########Download network segs from old JSS to xml file
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/networksegments/id/$i > /tmp/net.xml

############upload net segs from XML to new JSS
curl -k -s -u $apiuser:$apipass $newjss/JSSResource/networksegments/id/$i -T /tmp/net.xml -X POST
done



#######Moving Categories from old JSS to new JSS ###############################################################


for i in {1..100}
do
#########Download Categories from old JSS to xml file
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/categories/id/$i > /tmp/cats.xml

############upload Categories from XML to new JSS
curl -k -s -u $apiuser:$apipass $newjss/JSSResource/categories/id/$i -T /tmp/cats.xml -X POST

done

########Computer Groups ###############################################################


for i in {1..700}
do
###########Download Computer groups from old JSS to xml file
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/computergroups/id/$i > /tmp/cpugrps.xml

#########upload Computer Groups from xml file to new JSS
curl -k -s -u $apiuser:$apipass $newjss/JSSResource/computergroups/id/$i -T /tmp/cpugrps.xml -X POST
done



#########Scripts ###############################################################
########
######### This doesn't work it won't pull the actual script--- Work in Progress
#########

for i in {1..300}
do
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/scripts/id/$i > /tmp/scripts.xml

curl -k -s -u $apiuser:$apipass $newjss/JSSResource/scripts/id/$i -T /tmp/scripts.xml -X POST
done
###############################

#########Disk Encrypt Config ###############################################################
########
######### 
#########

for i in {1..30}
do
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/diskencryptionconfigurations/id/$i > /tmp/dkg.xml

curl -k -s -u $apiuser:$apipass $newjss/JSSResource/diskencryptionconfigurations/id/$i -T /tmp/dkg.xml -X POST
done

#########Advanced computer Searches ###############################################################
########
######### 
#########

for i in {1..100}
do
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/advancedcomputersearches/id/$i > /tmp/avs.xml

curl -k -s -u $apiuser:$apipass $newjss/JSSResource/advancedcomputersearches/id/$i -T /tmp/avs.xml -X POST
done

#########Directory Bindings ###############################################################
########
######### 
#########

for i in {1..50}
do
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/directorybindings/id/$i > /tmp/avs.xml

curl -k -s -u $apiuser:$apipass $newjss/JSSResource/directorybindings/id/$i -T /tmp/avs.xml -X POST
done

#########Printers ###############################################################
########
######### 
#########

for i in {1..200}
do
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/printers/id/$i > /tmp/avs.xml

curl -k -s -u $apiuser:$apipass $newjss/JSSResource/printers/id/$i -T /tmp/avs.xml -X POST
done


#########Packages ###############################################################
########
######### This will not add the Packages to a DP, it just adds the info in the JSS
#########

for i in {1..1500}
do
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/packages/id/$i > /tmp/pkg.xml

curl -k -s -u $apiuser:$apipass $newjss/JSSResource/packages/id/$i -T /tmp/pkg.xml -X POST
done
###############################
####### Policies convert over ###############################################################

for i in {1..3000}
do
##########Download the Policies from old JSS to xml file

curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/policies/id/$i > /tmp/policies.xml

########due to if certain items don't exist when we upload to new JSS it won't upload we remove them from the policy , we always remove scope so a policy just doesn't run as soon as it gets imported. Comment out and of the sed lines if your sure that line exists in new JSS

###### removes scope from policy
sed -ie 's/<scope>.*<\/scope>//g' /tmp/policies.xml

####removes any attached Packages from policy
#sed -ie 's/<packages>.*<\/packages>//g' /tmp/policies.xml

###### removes any Categories from Policy
#sed -ie 's/<category>.*<\/category>//g' /tmp/policies.xml

###### removes any scripts attached to policy
#sed -ie 's/<scripts>.*<\/scripts>//g' /tmp/policies.xml

##### removes any Dock items
sed -ie 's/<dock>.*<\/dock>//g' /tmp/policies.xml

##### removes it from Self Service 
sed -ie 's/<self_service>.*<\/self_service>//g' /tmp/policies.xml


############## upload policies from xml to new JSS
curl -k -s -u $apiuser:$apipass $newjss/JSSResource/policies/id/$i -T /tmp/policies.xml -X POST

done



########## Moving over os X configuration Profiles ###############################################################
for i in {1..50}
do

########## Download Configuration Profiles from old jss to xml file
curl -k -s -u $apiuser:$apipass $oldjss/JSSResource/osxconfigurationprofiles/id/$i > /tmp/configprofiles.xml

########due to if certain items don't exist when we upload to new JSS it won't upload we remove them from the configuration policy , we always remove scope so a policy just doesn't run as soon as it gets imported. Comment out and of the sed lines if your sure that line exists in new JSS

##### remove scope from Configuration profile
sed -ie 's/<scope>.*<\/scope>//g' /tmp/configprofiles.xml

##### remove Categories from Configuration Profiles
sed -ie 's/<category>.*<\/category>//g' /tmp/configprofiles.xml

####################upload Config PRofiles from xml to new JSS
curl -k -s -u $apiuser:$apipass $newjss/JSSResource/osxconfigurationprofiles/id/$i -T /tmp/configprofiles.xml -X POST


done


