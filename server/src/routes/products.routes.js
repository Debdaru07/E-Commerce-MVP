import { Router } from 'express'
import {
  getAllProducts,
  createProduct,
  updateProduct,
  deleteProduct
} from '../controllers/products.controller.js'

const router = Router()

import { verifyToken } from '../middleware/auth.js'
import { requireRole } from '../middleware/role.js'
// Middleware to protect dealer routes

/**
 * PUBLIC / CONSUMER
 * Get all active products
 */
router.get('/', getAllProducts)

/**
 * DEALER
 * Create product
 */
router.post('/', createProduct)

/**
 * DEALER
 * Update product
 */
router.put('/:id', updateProduct)

/**
 * DEALER
 * Delete product
 */
router.delete('/:id', deleteProduct)

export default router
