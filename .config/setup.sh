#!/bin/bash
# setup.sh: Build & configure a static website for portfolio.
# deploy with:
#   > cd .hugo && hugo --gc --minify --baseURL <BASE_URL>

# REQUIREMENTS
# 1) Environments Variables:
#   * GIT_DATE
#
# 2) Programs:
#   * hugo
#   * libreoffice
#   * jq
#
# 3) Fonts:
#   * Open Sans
#   * Font Awesome 4.7
#

set -e # exit on failure (avoid false success)


CONF_DIR=.config

HUGO_ROOT_DIR=.hugo
HUGO_CONTENT_DIR=$HUGO_ROOT_DIR/content/json_resume
HUGO_DATA_DIR=$HUGO_ROOT_DIR/data/json_resume
HUGO_STATIC_DIR=$HUGO_ROOT_DIR/static
HUGO_ASSETS_DIR=$HUGO_ROOT_DIR/assets

###############################################################################
# STEP 0: Requirements                                                        #
###############################################################################

# remove previous build
rm -rf $HUGO_ROOT_DIR

###############################################################################
# STEP 1: Setup the HuGo boilerplate                                          #
###############################################################################

hugo new site $HUGO_ROOT_DIR
cd $HUGO_ROOT_DIR
hugo mod init github.com/XavierBrassoud/autofolio
cd ..
[ -e $HUGO_ROOT_DIR/hugo.toml ] && rm $HUGO_ROOT_DIR/hugo.toml
[ -e $HUGO_ROOT_DIR/config.toml ] && rm $HUGO_ROOT_DIR/config.toml
mkdir -p $HUGO_CONTENT_DIR
mkdir -p $HUGO_DATA_DIR

cp $CONF_DIR/hugo.yaml $HUGO_ROOT_DIR/hugo.yaml
cp CHANGELOG.md $HUGO_CONTENT_DIR/CHANGELOG.md
cp resume_en.json $HUGO_DATA_DIR/en.json
cp resume_fr.json $HUGO_DATA_DIR/fr.json
cp $CONF_DIR/favicon.ico $HUGO_STATIC_DIR
cp -r img $HUGO_ASSETS_DIR

# setup the HuGo theme
cd $HUGO_ROOT_DIR
hugo mod get github.com/XavierBrassoud/hugo-theme-vertica-resume
cd ..


###############################################################################
# STEP 3: Populate json_resumes `meta.version` `meta.date` with last commit   #
###############################################################################

cat $HUGO_DATA_DIR/en.json | jq '.meta.lastModified = env.GIT_DATE' > $HUGO_DATA_DIR/en.json.tmp && mv $HUGO_DATA_DIR/en.json.tmp $HUGO_DATA_DIR/en.json
cat $HUGO_DATA_DIR/fr.json | jq '.meta.lastModified = env.GIT_DATE' > $HUGO_DATA_DIR/fr.json.tmp && mv $HUGO_DATA_DIR/fr.json.tmp $HUGO_DATA_DIR/fr.json


###############################################################################
# STEP 4: Generate PDF from libreoffice docs                                  #
###############################################################################

libreoffice --headless --convert-to pdf resume_en.fodp --outdir $HUGO_ROOT_DIR
libreoffice --headless --convert-to pdf resume_fr.fodp --outdir $HUGO_ROOT_DIR

mkdir -p $HUGO_STATIC_DIR/en

mv $HUGO_ROOT_DIR/resume_en.pdf $HUGO_STATIC_DIR/en/cv.pdf
mv $HUGO_ROOT_DIR/resume_fr.pdf $HUGO_STATIC_DIR/cv.pdf  # default language
