from fastapi import APIRouter

router = APIRouter()

api_id = "zeitplanEquipoEliminar"
api_route = "/equipos/{equipo_id}"
metodo = "delete"


@router.delete(api_route)
async def api1_delete(equipo_id: str):
    return {"message": "Hello from deleting equipo - DELETE from VSC"}
