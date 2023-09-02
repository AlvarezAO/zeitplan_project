from fastapi import APIRouter

router = APIRouter()

api_id = "zeitplanEquipoObtener"
api_route = "/equipos/{equipo_id}"
metodo = "get"


@router.get(api_route)
async def api1_get(equipo_id: str):
    return {"message": "Hello from getting a equipo - GET"}