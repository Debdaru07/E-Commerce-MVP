/**
 * Product Response DTO - Data Layer
 * Formats product data for API responses
 */
export class ProductResponseDto {
  constructor(product) {
    this.id = product.id
    this.dealerId = product.dealerId
    this.categoryId = product.categoryId
    this.title = product.title
    this.description = product.description
    this.unitPrice = product.unitPrice
    this.stock = product.stock
    this.isActive = product.isActive
    this.createdAt = product.createdAt
    this.updatedAt = product.updatedAt
  }

  /**
   * Convert to plain object for JSON response
   */
  toJSON() {
    return {
      id: this.id,
      dealer_id: this.dealerId,
      category_id: this.categoryId,
      title: this.title,
      description: this.description,
      unit_price: this.unitPrice,
      stock: this.stock,
      is_active: this.isActive,
      created_at: this.createdAt,
      updated_at: this.updatedAt
    }
  }
}

/**
 * Product List Response DTO - Data Layer
 * Formats product list data for API responses
 */
export class ProductListResponseDto {
  constructor(products, totalCount = null) {
    this.products = products.map(product => new ProductResponseDto(product).toJSON())
    this.totalCount = totalCount
  }

  toJSON() {
    const result = { products: this.products }
    if (this.totalCount !== null) {
      result.totalCount = this.totalCount
    }
    return result
  }
}