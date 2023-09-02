from fastapi import FastAPI
from mangum import Mangum

from api.Equipos.GET.routes import router as get_equipo
from api.Equipos.DELETE.routes import router as delete_equipo
from api.Equipos.POST.routes import router as post_equipo

app = FastAPI()

app.include_router(get_equipo)
app.include_router(delete_equipo)
app.include_router(post_equipo)

# La función handler debe tener el siguiente nombre y firma:
def lambda_handler(event, context):
    # Crea una instancia de Mangum con tu aplicación FastAPI
    mangum_handler = Mangum(app)

    # Invoca el manejador de Mangum con el evento y el contexto proporcionados por AWS Lambda
    return mangum_handler(event, context)
