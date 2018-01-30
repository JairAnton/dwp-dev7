#!/usr/bin/python

import xml.etree.ElementTree as ET
import shutil
import sys
import glob
import os

sourcedir = sys.argv[1]
targetdir = sys.argv[2]
print "source dir: ", sourcedir
print "target dir: ", targetdir

if os.path.exists('tmp'):
    shutil.rmtree('tmp')
os.makedirs('tmp')
shutil.copyfile(targetdir + os.path.sep + 'package.xml',
                'tmp' + os.path.sep + 'package.xml')
if os.path.exists(targetdir):
    shutil.rmtree(targetdir)
os.makedirs(targetdir)
shutil.copyfile('tmp' + os.path.sep + 'package.xml',
                targetdir + os.path.sep + 'package.xml')


# Types / Directories
typeToDir = {"ApexClass": "classes",
             "ApexPage": "pages",
             "ApexTrigger": "triggers",
             "AuraDefinitionBundle": "aura",
             "CustomTab": "tabs",
             "ContentAsset": "contentassets",
             "CustomApplication": "applications",
             "CustomLabel": "labels",
             "CustomMetadata": "customMetadata",
             "Queue": "queues",
             "CustomObject": "objects",
             "CustomObjectTranslation": "objectTranslations",
             "FlexiPage": "flexipages",
             "Group": "groups",
             "Layout": "layouts",
             "MatchingRule": "matchingRules",
             "PathAssistant": "pathAssistants",
             "Profile": "profiles",
             "QuickAction": "quickActions",
             "Report": "reports",
             "SharingCriteriaRule": "sharingRules",
             "StaticResource": "staticresources",
             "Translations": "translations",
             "Flow": "flows",
             "Workflow": "workflows",
             "DuplicateRule": "duplicateRules",
             "PlatformCachePartition": "cachePartitions",
             "RemoteSiteSetting": "remoteSiteSettings",
             "Role":"roles",
			 "Dashboard":"dashboards",
			 "ReportType":"reportTypes",
			 "PermissionSet":"permissionsets",
             "StandardValueSetTranslation":"standardValueSetTranslations",
             "StandardValueSet":"standardValueSets",
             "Certificate":"certs"
             }

tree = ET.parse(targetdir + os.path.sep + 'package.xml')
root = tree.getroot()
print root.tag
for child in root.findall('{http://soap.sforce.com/2006/04/metadata}types'):
    print "------------"
    print child.find('{http://soap.sforce.com/2006/04/metadata}name').text
    print "------------"
    try:
        name = child.find(
            '{http://soap.sforce.com/2006/04/metadata}name').text
        currentFolder = typeToDir[name]
        print currentFolder
        if not os.path.exists(targetdir + os.path.sep + currentFolder):
            os.makedirs(targetdir + os.path.sep + currentFolder)
        for member in child.findall('{http://soap.sforce.com/2006/04/metadata}members'):
            print member.text
            try:
                src = sourcedir + os.path.sep + currentFolder + os.path.sep + member.text
                tgt = targetdir + os.path.sep + currentFolder + os.path.sep
                print src, tgt
                if name == "SharingCriteriaRule":
                    src = src[:src.rfind(".")] + ".*"
                elif name == "Report" or name == "Dashboard":
                    if "/" not in member.text: 
                        os.makedirs(tgt + member.text)
                        i = 0
                        for file1 in glob.glob(src):
                            i = i+1
                            print ("copy file " + file1 +"-meta.xml to "+tgt)
                            shutil.copy(file1+"-meta.xml", tgt)   
                        if i==0:
                            print ("copy file " + src +"-meta.xml to "+tgt)
                            shutil.copy(src+"-meta.xml", tgt) 
                elif name != "AuraDefinitionBundle":
                    src = src + ".*"
                else:
                    os.makedirs(tgt + member.text)       
                for file1 in glob.glob(src):
                    print "in for:", file1
                    if (os.path.isdir(file1)):
                        print "is dir to ", file1 + os.path.sep + "*", tgt + member.text
                        for fileInDir in glob.glob(file1 + os.path.sep + "*"):
                            shutil.copy(fileInDir, tgt + member.text)
                    else:
                        print ("copy file " + file1 +".* to "+tgt)
                        shutil.copy(file1, tgt)      
            except IOError as e:
                print "IOError({0}): {1}".format(e.errno, e.strerror)
    except KeyError:
        pass

shutil.rmtree('tmp')