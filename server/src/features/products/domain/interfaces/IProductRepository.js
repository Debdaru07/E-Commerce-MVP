/**
 * Product Repository Interface - Domain Layer
 * Defines the contract for product data operations
 */
export class IProductRepository {
  /**
   * Find all active products with optional filters
   * @param {Object} filters - Filter criteria
   * @returns {Promise<Product[]>}
   */
  async findAll(filters = {}) {
    throw new Error('Method not implemented')
  }

  /**
   * Find product by ID
   * @param {string} id - Product ID
   * @returns {Promise<Product|null>}
   */
  async findById(id) {
    throw new Error('Method not implemented')
  }

  /**
   * Find products by dealer ID
   * @param {string} dealerId - Dealer ID
   * @returns {Promise<Product[]>}
   */
  async findByDealerId(dealerId) {
    throw new Error('Method not implemented')
  }

  /**
   * Create a new product
   * @param {Object} productData - Product data
   * @returns {Promise<Product>}
   */
  async create(productData) {
    throw new Error('Method not implemented')
  }

  /**
   * Update an existing product
   * @param {string} id - Product ID
   * @param {Object} updateData - Update data
   * @returns {Promise<Product>}
   */
  async update(id, updateData) {
    throw new Error('Method not implemented')
  }

  /**
   * Delete a product
   * @param {string} id - Product ID
   * @returns {Promise<boolean>}
   */
  async delete(id) {
    throw new Error('Method not implemented')
  }
}