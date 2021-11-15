import styled from 'styled-components'
import { buttonStyle } from 'styled-system'
import { Common, Typography, Border, Layout, Flex, CommonProps, TypographyProps, BorderProps, LayoutProps, FlexProps } from 'theme/constants'

export type ButtonProps = CommonProps & TypographyProps & BorderProps & LayoutProps & FlexProps

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
}

export default Button
