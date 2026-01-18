export const getProfile = (req, res) => {
  return res.json({
    success: true,
    data: {
      role: req.user.role,
      full_name: req.user.full_name,
      email: req.user.email
    }
  })
}
