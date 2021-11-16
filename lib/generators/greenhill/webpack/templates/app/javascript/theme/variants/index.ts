/* eslint-disable @typescript-eslint/ban-types */

import { buttons, Buttons } from './buttons'

export interface Variants {
  buttons?: Buttons
  colorStyles?: {}
  textStyles?: {}
}

export const variants: Variants = {
  buttons
}

export default variants