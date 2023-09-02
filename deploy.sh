#!/bin/bash

# Lee la variable de entorno AWS_LAMBDA_ALIAS o argumento para determinar el alias
if [ -z "$AWS_LAMBDA_ALIAS" ]; then
  alias="development"  # Valor predeterminado si no se proporciona la variable de entorno
else
  alias="$AWS_LAMBDA_ALIAS"
fi

echo "Implementando en el alias de Lambda: $alias"

# Variables de entorno para el bucket S3 y la región de AWS
BUCKET_NAME="kimelt-bucket"
AWS_REGION="us-east-1"
AWS_STACK="kimeltStack"
RUTA=$(cd "$(dirname "$0")" && pwd)

# Verificar la existencia de AWS CLI en el sistema
if ! command -v aws &>/dev/null; then
    echo "Error: AWS CLI no está instalado en el sistema."
    exit 1
fi

# Run generate_template.sh
./generate_template.sh

HORA=$(date '+%Y-%m-%d %H:%M:%S')

echo "Comenzando Deploy a las: $HORA"

set -e

echo "Crear la carpeta para las dependencias"
DEPENDENCIES="dependencies/python/lib/python3.8/site-packages"
mkdir -p $DEPENDENCIES

echo "Instalar las dependencias en la carpeta 'dependencies'"
pip install -r requirements.txt --target $DEPENDENCIES

echo "Crear el archivo zip de las dependencias"
cd dependencies
echo $RUTA
zip -r $RUTA/layer.zip .

cd ..

echo "Desplegar la aplicación"


sam package --template-file $RUTA/template.yaml --output-template-file $RUTA/packaged.yaml --s3-bucket $BUCKET_NAME --region $AWS_REGION
sam deploy --template-file $RUTA/packaged.yaml --stack-name $AWS_STACK --capabilities CAPABILITY_IAM --region $AWS_REGION
echo "Eliminar la carpeta 'dependencies'"

rm -rf $RUTA/dependencies
rm -f $RUTA/packaged.yaml
rm -rf $RUTA/layer.zip
echo "Terminando Deploy a las: $(date '+%Y-%m-%d %H:%M:%S')"
