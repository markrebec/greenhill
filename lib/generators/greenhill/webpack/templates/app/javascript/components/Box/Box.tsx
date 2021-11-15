import styled from 'styled-components'
import { Common, Layout, Flex, Position, CommonProps, LayoutProps, FlexProps, PositionProps } from 'theme/constants'

export type BoxProps = CommonProps & LayoutProps & FlexProps & PositionProps

export const Box = styled.div<BoxProps>`
  ${Common};
  ${Layout};
  ${Flex};
  ${Position};
`

export default Box
