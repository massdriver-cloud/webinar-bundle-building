mass_push:
	cd app && mass image push massdriver/lambda_s3_demo -a ${ARTIFACT_ID} -r us-east-1

mass_publish:
	cd lambda_bundle && mass bundle lint
	cd lambda_bundle && mass bundle build
	cd lambda_bundle && mass bundle publish
