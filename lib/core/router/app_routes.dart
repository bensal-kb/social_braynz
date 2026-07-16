class Routes {
  Routes._();

  static const productList = '/';
  static const lowStock = '/low-stock';
  static const addProduct = '/products/new';
  static const productDetail = '/products/:id';
  static const editProduct = '/products/:id/edit';
  static const logSale = '/products/:id/log-sale';

  static String productDetailPath(String id) => '/products/$id';
  static String editProductPath(String id) => '/products/$id/edit';
  static String logSalePath(String id) => '/products/$id/log-sale';
}
