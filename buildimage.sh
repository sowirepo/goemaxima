##/bin/bash
# arg1: sbcl version
# arg2: maxima version
# arg3: stack or moodle version: "stack-XXX" or "moodlev.X"
# arg4: LIB_PATH
# arg5: REGISTRY or dockerhub id
# arg6: version of goemaxima
#
echo "starting to build image for:"
echo "sbcl: $1"
echo "maxima: $2"
echo "stack: $3"
IMAGENAME="goemaxima:$3"
docker pull "$5/$IMAGENAME-dev"
# build it
docker build -t "${IMAGENAME}" --build-arg MAXIMA_VERSION="$2" --build-arg SBCL_VERSION="$1" --build-arg LIB_PATH="$4" . || exit 1
echo "${IMAGENAME} wurde erfolgreich gebaut."
# push the image
docker tag "$IMAGENAME" "$5/$IMAGENAME-dev"
docker push "$5/$IMAGENAME-dev"
if [ -n "$6" ]; then
	docker tag "$IMAGENAME" "$5/$IMAGENAME-$6"
	docker push "$5/$IMAGENAME-$6"
	docker tag "$IMAGENAME" "$5/$IMAGENAME-latest"
	docker push "$5/$IMAGENAME-latest"
fi
