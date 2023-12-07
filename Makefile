mass_push:
	cd app && mass image push massdriver/lambda_s3_demo -a ${ARTIFACT_ID} -r us-east-1

mass_publish:
	cd compute && mass bundle lint
	cd compute && mass bundle publish
