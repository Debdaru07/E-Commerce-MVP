/**
 * Product Entity - Domain Layer
 * Represents the core business concept of a Product
 */
export class Product {
  constructor({
    id,
    dealerId,
    categoryId,
    title,
    description,
    unitPrice,
    stock,
    isActive,
    createdAt,
    updatedAt
  }) {
    this.id = id
    this.dealerId = dealerId
    this.categoryId = categoryId
    this.title = title
    this.description = description
    this.unitPrice = unitPrice
    this.stock = stock
    this.isActive = isActive
    this.createdAt = createdAt
    this.updatedAt = updatedAt
  }

  /**
   * Business logic: Check if product is available for purchase
   */
  isAvailable() {
    return this.isActive && this.stock > 0
  }

  /**
   * Business logic: Check if dealer owns this product
   */
  isOwnedBy(dealerId) {
    return this.dealerId === dealerId
  }

  /**
   * Business logic: Update product stock
   */
  updateStock(newStock) {
    if (newStock < 0) {
      throw new Error('Stock cannot be negative')
    }
    this.stock = newStock
    this.updatedAt = new Date()
  }
}