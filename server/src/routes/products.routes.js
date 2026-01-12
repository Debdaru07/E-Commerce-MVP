import { Router } from 'express'

import {
  getAllProducts,
  createProduct,
  updateProduct,
  deleteProduct,
   getDealerProducts

} from '../controllers/products.controller.js'

import { verifyToken } from '../middleware/auth.js'
import { requireRole } from '../middleware/role.js'

const router = Router()

/**
 * PUBLIC / CONSUMER
 * Get all active products
 * Supports filters & sorting via query params
 */
router.get('/', getAllProducts)



/**
 * DEALER
 * Get own products (⚠️ must be before /:id)
 */
router.get(
  '/dealer/my-products',
  verifyToken,
  requireRole('DEALER'),
  getDealerProducts
)
/**
 * DEALER ONLY
 * Create product
 */
router.post(
  '/',
  verifyToken,
  requireRole('DEALER'),
  createProduct
)

/**
 * DEALER ONLY
 * Update own product
 */
router.put(
  '/:id',
  verifyToken,
  requireRole('DEALER'),
  updateProduct
)

/**
 * DEALER ONLY
 * Delete own product
 */
router.delete(
  '/:id',
  verifyToken,
  requireRole('DEALER'),
  deleteProduct
)




export default router
