import { Router } from "express";

import {
  aniosDisponiblesPivotControlador,
  catalogoPivotControlador,
  ejecutarPivotControlador,
  valoresDimensionPivotControlador,
  estadisticasCacheControlador
} from "../controladores/pivot.controlador";
import {
  establecerConfiguracionBD,
  limpiarConfiguracionBD,
  logConfiguracionBD,
  requerirConfiguracionBD
} from "../middleware/configuracion-bd.middleware";
import { simpleRateLimit } from "../utilidades/rate-limit.utilidad";

const router = Router();

// Rate limiting para consultas pivot (máx 10 consultas por minuto por IP)
// Con 16GB RAM y 50 conexiones, podemos ser más permisivos
const pivotRateLimit = simpleRateLimit({
  windowMs: 60_000, // 1 minuto
  max: 10, // 10 consultas por minuto por usuario
  keyGenerator: (req) => `pivot:${req.ip || "unknown"}`
});

// Rate limiting más permisivo para catálogos (máx 60 por minuto)
const catalogoRateLimit = simpleRateLimit({
  windowMs: 60_000,
  max: 60,
  keyGenerator: (req) => `catalogo:${req.ip || "unknown"}`
});

router.use(establecerConfiguracionBD);
router.use(logConfiguracionBD);
router.use(requerirConfiguracionBD);
router.use(limpiarConfiguracionBD);

router.get("/catalogo", catalogoRateLimit, catalogoPivotControlador);
router.get("/anios", catalogoRateLimit, aniosDisponiblesPivotControlador);
router.get("/dimensiones/:dimensionId/valores", catalogoRateLimit, valoresDimensionPivotControlador);
router.post("/consulta", pivotRateLimit, ejecutarPivotControlador);
router.get("/cache/stats", estadisticasCacheControlador);

export default router;






