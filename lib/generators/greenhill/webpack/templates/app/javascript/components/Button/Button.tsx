import styled from 'styled-components'
import { buttonStyle, ButtonStyleProps } from 'styled-system'
import { Common, Typography, Border, Layout, Flex, CommonProps, TypographyProps, BorderProps, LayoutProps, FlexProps } from 'theme/constants'

export type ButtonProps = CommonProps & TypographyProps & BorderProps & LayoutProps & FlexProps & ButtonStyleProps

export const Button = styled.button<ButtonProps>`
  box-sizing: border-box;
  cursor: pointer;
  outline: none;
  ${Typography};
  ${Common};
  ${Border};
  ${Layout};
  ${Flex};
  ${buttonStyle};
`
Button.defaultProps = {
  fontFamily: 'body',
  borderWidth: '1px',
  borderStyle: 'solid',
  boxShadow: 'none',
  px: [2],
  py: [1],
}

export default Button
