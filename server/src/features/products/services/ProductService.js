import { ProductRepository } from '../data/repositories/ProductRepository.js'
import { ProductMapper } from '../data/mappers/ProductMapper.js'
import { CreateProductRequestDto, UpdateProductRequestDto } from '../data/dtos/ProductRequestDtos.js'

/**
 * Product Service - Service Layer
 * Contains business logic for product operations
 */
export class ProductService {
  constructor() {
    this.productRepository = new ProductRepository()
  }

  /**
   * Get all active products with optional filters
   * @param {Object} filters - Filter criteria
   * @returns {Promise<Object[]>}
   */
  async getAllProducts(filters = {}) {
    const products = await this.productRepository.findAll(filters)
    return ProductMapper.toResponseDtoList(products)
  }

  /**
   * Create a new product
   * @param {Object} productData - Raw product data from request
   * @param {string} dealerId - Dealer ID
   * @returns {Promise<Object>}
   */
  async createProduct(productData, dealerId) {
    const dto = new CreateProductRequestDto(productData)
    const dbData = ProductMapper.createRequestToDatabase(dto, dealerId)

    const product = await this.productRepository.create(dbData)
    return ProductMapper.toResponseDto(product)
  }

  /**
   * Update an existing product
   * @param {string} productId - Product ID
   * @param {Object} updateData - Raw update data from request
   * @param {string} dealerId - Dealer ID for ownership validation
   * @returns {Promise<Object>}
   */
  async updateProduct(productId, updateData, dealerId) {
    const dto = new UpdateProductRequestDto(updateData)

    if (!dto.hasUpdates()) {
      throw new Error('No valid fields to update')
    }

    // Check if product exists and belongs to dealer
    const existingProduct = await this.productRepository.findById(productId)
    if (!existingProduct) {
      throw new Error('Product not found')
    }

    if (!existingProduct.isOwnedBy(dealerId)) {
      throw new Error('Product not owned by dealer')
    }

    const dbData = ProductMapper.updateRequestToDatabase(dto)
    const updatedProduct = await this.productRepository.update(productId, dbData)

    return ProductMapper.toResponseDto(updatedProduct)
  }

  /**
   * Delete a product
   * @param {string} productId - Product ID
   * @param {string} dealerId - Dealer ID for ownership validation
   * @returns {Promise<void>}
   */
  async deleteProduct(productId, dealerId) {
    // Check if product exists and belongs to dealer
    const existingProduct = await this.productRepository.findById(productId)
    if (!existingProduct) {
      throw new Error('Product not found')
    }

    if (!existingProduct.isOwnedBy(dealerId)) {
      throw new Error('Product not owned by dealer')
    }

    const deleted = await this.productRepository.delete(productId)
    if (!deleted) {
      throw new Error('Product not found')
    }
  }

  /**
   * Get all products for a specific dealer
   * @param {string} dealerId - Dealer ID
   * @returns {Promise<Object[]>}
   */
  async getDealerProducts(dealerId) {
    const products = await this.productRepository.findByDealerId(dealerId)
    return ProductMapper.toResponseDtoList(products)
  }
}