from fastapi import APIRouter

router = APIRouter()

api_id = "zeitplanEquipoAgregar"
api_route = "/equipos"
metodo = "post"


@router.post(api_route)
async def api1_post():
    return {"message": "Hello from adding equipo - POST"}
