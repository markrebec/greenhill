import Color from 'color'

export type Mix = (clr: string, mxc: string, val: number) => Color;

export const mix: Mix = (clr: string, mxc: string, val: number): Color => Color(clr).mix(Color(mxc), val)

export default mix
