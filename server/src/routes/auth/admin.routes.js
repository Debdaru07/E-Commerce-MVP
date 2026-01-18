import { Router } from 'express'
import {
  loginAdmin,
  getAdminProfile
} from '../../controllers/auth/admin.controller.js'

import { verifyToken } from '../../middleware/auth.js'
import { requireRole } from '../../middleware/role.js'

const router = Router()

// ADMIN LOGIN
router.post('/login', loginAdmin)

// ADMIN PROFILE
router.get(
  '/me',
  verifyToken,
  requireRole('ADMIN'),
  getAdminProfile
)

export default router
