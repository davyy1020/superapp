import mysql from 'mysql2/promise';

let pool;

export function getMySqlPool() {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT) || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'bispira_db',
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0,
      enableKeepAlive: true,
      keepAliveInitialDelay: 10000,
    });
  }
  return pool;
}

export async function queryMySql(sql, params = []) {
  const p = getMySqlPool();
  const [rows] = await p.execute(sql, params);
  return rows;
}

export async function checkMySqlConnection() {
  try {
    const p = getMySqlPool();
    const [rows] = await p.query('SELECT 1 as is_alive, DATABASE() as current_db, VERSION() as mysql_version');
    return {
      connected: true,
      data: rows[0],
    };
  } catch (err) {
    return {
      connected: false,
      error: err.message,
    };
  }
}

