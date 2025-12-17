import express from "express";
import path from "path";
import cors from "cors";
import helmet from "helmet";
import compression from "compression";

import { entorno } from "./configuracion";
import rutas from "./rutas/index.routes";
import { httpLogger } from "./utilidades/registro.utilidad";
import {
  errorHandler,
  notFoundHandler,
  requestIdMiddleware,
} from "./utilidades/error.utilidad";
import { simpleRateLimit } from "./utilidades/rate-limit.utilidad";

const app = express();

// Confiar en proxy (NGINX)
app.set("trust proxy", true);

/**
 * ================================
 * SEGURIDAD BÁSICA
 * ================================
 */
app.use(
  helmet({
    crossOriginResourcePolicy: { policy: "cross-origin" },
    frameguard: false,
  })
);

/**
 * ================================
 * CORS (FRONTEND ↔ BACKEND)
 * ================================
 */
const ORIGENES_PERMITIDOS = process.env.CORS_ORIGINS
  ? process.env.CORS_ORIGINS.split(",").map((o) => o.trim())
  : ["http://172.16.36.59"];

app.use(
  cors({
    origin: (origin, callback) => {
      // Permitir llamadas sin header Origin (curl, healthcheck, server-to-server)
      if (!origin) return callback(null, true);

      if (ORIGENES_PERMITIDOS.includes(origin)) {
        return callback(null, true);
      }

      // En desarrollo, permitir todos los orígenes
      if (entorno.ambiente === "desarrollo") {
        return callback(null, true);
      }

      return callback(new Error("Origen no permitido por CORS"));
    },
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
    credentials: true,
  })
);

// El middleware de CORS arriba ya maneja automáticamente las peticiones OPTIONS
// En Express 5, no se puede usar "*" como ruta

/**
 * ================================
 * MIDDLEWARES GENERALES
 * ================================
 */
app.use(compression());
app.use(express.json({ limit: "1mb" }));
app.use(express.urlencoded({ extended: true }));
app.use(httpLogger);
app.use(requestIdMiddleware);
app.use(simpleRateLimit({ windowMs: 60_000, max: 300 }));

/**
 * ================================
 * ENDPOINT DE SALUD
 * ================================
 */
app.get("/salud", (_req, res) => {
  res.json({
    estado: "ok",
    servicio: "bi-backend",
    ambiente: entorno.ambiente,
  });
});

/**
 * ================================
 * RUTAS DE API
 * ================================
 */
app.use("/api", rutas);

/**
 * ================================
 * ARCHIVOS ESTÁTICOS (si aplica)
 * ================================
 */
app.use(express.static(path.join(__dirname, "..", "public")));

/**
 * ================================
 * MANEJO DE ERRORES
 * ================================
 */
app.use(notFoundHandler);
app.use(errorHandler);

export { app };
