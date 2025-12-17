/**
 * Configuración PM2 para BI SESAL Backend
 * Modo cluster con 2 instancias para alta disponibilidad
 */
module.exports = {
  apps: [
    {
      name: "bisesal-backend",
      script: "./dist/server.js",
      instances: "max", // Usar todos los cores disponibles
      exec_mode: "cluster",
      env: {
        NODE_ENV: "production",
        PORT: 4000,
        MYSQL_HOST: "172.16.34.68",
        MYSQL_PORT: 3306,
        MYSQL_USER: "root",
        MYSQL_PASSWORD: "Animalit0..9",
        MYSQL_DATABASE: "sesal_historico",
        MYSQL_CONNECTION_LIMIT: 50,
        MYSQL_QUEUE_LIMIT: 200,
        MYSQL_CONNECT_TIMEOUT: 20000,
        MYSQL_CHARSET: "utf8mb4",
        MYSQL_QUERY_TIMEOUT: 300000,
        CORS_ORIGINS: "http://172.16.36.59",
      },
      // Logs
      error_file: "./logs/error.log",
      out_file: "./logs/out.log",
      log_file: "./logs/combined.log",
      time: true,
      log_date_format: "YYYY-MM-DD HH:mm:ss Z",
      merge_logs: true,

      // Gestión de memoria
      max_memory_restart: "500M",

      // Comportamiento
      autorestart: true,
      watch: false,
      max_restarts: 10,
      min_uptime: "10s",

      // Variables de entorno adicionales
      env_production: {
        NODE_ENV: "production",
      },
    },
  ],
};
