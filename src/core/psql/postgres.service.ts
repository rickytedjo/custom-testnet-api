import { Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Client } from 'pg'

@Injectable()
export class PostgresService {
  private client: Client;
  constructor(private readonly config: ConfigService) {
    const connStr = this.config.get<string>('DATABASE_URL');
    if (!connStr) {
      throw new Error('DATABASE_URL is missing from configuration.');
    }
  
    this.client = new Client({
      connectionString: connStr,
    });
  }

  async onModuleInit() {
    console.log('Connecting to Postgres...');
    await this.connect(); // or initialize pool
  }

  async onModuleDestroy() {
    await this.disconnect();
  }

  async connect() {
      await this.client.connect();
  }

  async disconnect() {
      await this.client.end();
  }

  async getAll<T = any>(table: string, filters?: Record<string, any>): Promise<T[]> {
    let query = `SELECT * FROM ${table}`;
    const values: any[] = [];
    
    if (filters && Object.keys(filters).length > 0) {
      const conditions = Object.entries(filters).map(([key, value], idx) => {
        values.push(value);
        // use LOWER() for Ethereum address comparison
        return `LOWER(${key}) = LOWER($${idx + 1})`;
      });
      query += ` WHERE ` + conditions.join(' AND ');
    }
  
    const res = await this.client.query(query, values);
    return res.rows;
  }

  async insert<T = any>(table: string, data: Record<string, any>): Promise<T> {
    const keys = Object.keys(data)
    const values = Object.values(data)
    const placeholders = keys.map((_, i) => `$${i + 1}`).join(', ')

    const res = await this.client.query(
      `INSERT INTO ${table} (${keys.join(', ')}) VALUES (${placeholders}) RETURNING *`,
      values
    )
    return res.rows[0]
  }

  async update<T = any>(table: string, id: number, data: Record<string, any>): Promise<T> {
    const keys = Object.keys(data)
    const values = Object.values(data)
    const setClause = keys.map((key, i) => `${key} = $${i + 1}`).join(', ')

    const res = await this.client.query(
      `UPDATE ${table} SET ${setClause} WHERE id = $${keys.length + 1} RETURNING *`,
      [...values, id]
    )
    return res.rows[0]
  }

  async delete<T = any>(table: string, id: number): Promise<T> {
    const res = await this.client.query(
      `DELETE FROM ${table} WHERE id = $1 RETURNING *`,
      [id]
    )
    return res.rows[0]
  }

}