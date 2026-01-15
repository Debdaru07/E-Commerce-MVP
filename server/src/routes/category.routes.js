import { Router } from 'express'
import {
  getCategories,
  createCategory,
  updateCategory,
  deleteCategory
} from '../controllers/category.controller.js'

import { verifyToken } from '../middleware/auth.js'
import { requireRole } from '../middleware/role.js'

const router = Router()

/**
 * PUBLIC
 */
router.get('/', getCategories)

/**
 * ADMIN ONLY
 */
router.post('/', verifyToken, requireRole('ADMIN'), createCategory)

router.put(
  '/:categoryId',
  verifyToken,
  requireRole('ADMIN'),
  updateCategory
)

router.delete(
  '/:categoryId',
  verifyToken,
  requireRole('ADMIN'),
  deleteCategory
)

export default router
