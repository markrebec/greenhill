import axios from 'axios'

// The page is always served by Rails (vite_rails), so API requests are
// always same-origin — no /api prefix or dev-server proxy needed.
export const api = axios.create({
  baseURL: '/',
  headers: { Accept: 'application/json' },
})
