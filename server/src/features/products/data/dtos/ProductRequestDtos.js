/**
 * Create Product Request DTO - Data Layer
 * Validates and sanitizes incoming create product requests
 */
export class CreateProductRequestDto {
  constructor(data) {
    this.title = this.validateTitle(data.title)
    this.description = data.description || ''
    this.unitPrice = this.validateUnitPrice(data.unit_price)
    this.stock = this.validateStock(data.stock)
    this.categoryId = this.validateCategoryId(data.category_id)
  }

  validateTitle(title) {
    if (!title || typeof title !== 'string' || title.trim().length === 0) {
      throw new Error('Title is required and must be a non-empty string')
    }
    if (title.length > 255) {
      throw new Error('Title must be less than 255 characters')
    }
    return title.trim()
  }

  validateUnitPrice(price) {
    const numPrice = Number(price)
    if (isNaN(numPrice) || numPrice < 0) {
      throw new Error('Unit price must be a non-negative number')
    }
    return numPrice
  }

  validateStock(stock) {
    const numStock = Number(stock)
    if (isNaN(numStock) || numStock < 0) {
      throw new Error('Stock must be a non-negative number')
    }
    return numStock
  }

  validateCategoryId(categoryId) {
    if (!categoryId || typeof categoryId !== 'string') {
      throw new Error('Category ID is required and must be a string')
    }
    return categoryId
  }
}

/**
 * Update Product Request DTO - Data Layer
 * Validates and sanitizes incoming update product requests
 */
export class UpdateProductRequestDto {
  constructor(data) {
    this.updates = {}

    if (data.title !== undefined) {
      this.updates.title = this.validateTitle(data.title)
    }
    if (data.description !== undefined) {
      this.updates.description = data.description || ''
    }
    if (data.unit_price !== undefined) {
      this.updates.unitPrice = this.validateUnitPrice(data.unit_price)
    }
    if (data.stock !== undefined) {
      this.updates.stock = this.validateStock(data.stock)
    }
    if (data.category_id !== undefined) {
      this.updates.categoryId = this.validateCategoryId(data.category_id)
    }
    if (data.is_active !== undefined) {
      this.updates.isActive = this.validateIsActive(data.is_active)
    }
  }

  validateTitle(title) {
    if (typeof title !== 'string' || title.trim().length === 0) {
      throw new Error('Title must be a non-empty string')
    }
    if (title.length > 255) {
      throw new Error('Title must be less than 255 characters')
    }
    return title.trim()
  }

  validateUnitPrice(price) {
    const numPrice = Number(price)
    if (isNaN(numPrice) || numPrice < 0) {
      throw new Error('Unit price must be a non-negative number')
    }
    return numPrice
  }

  validateStock(stock) {
    const numStock = Number(stock)
    if (isNaN(numStock) || numStock < 0) {
      throw new Error('Stock must be a non-negative number')
    }
    return numStock
  }

  validateCategoryId(categoryId) {
    if (typeof categoryId !== 'string') {
      throw new Error('Category ID must be a string')
    }
    return categoryId
  }

  validateIsActive(isActive) {
    return Boolean(isActive)
  }

  hasUpdates() {
    return Object.keys(this.updates).length > 0
  }
}